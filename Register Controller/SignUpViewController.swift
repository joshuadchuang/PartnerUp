//
//  SignUpViewController.swift
//  PartnerUp
//
//  Created by Joshua Chuang on 12/24/20.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: Variables
    
    private let spinner = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var pfpImageView: UIImageView!
    
    
    // MARK: Loading Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        pfpImageView.layer.masksToBounds = true
        pfpImageView.layer.borderWidth = 2
        pfpImageView.layer.borderColor = UIColor.lightGray.cgColor
        pfpImageView.image = UIImage(systemName: "person.circle")
        pfpImageView.tintColor = .gray
        pfpImageView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(changeProfilePicTapped))
        
        pfpImageView.addGestureRecognizer(gesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.width/3
        pfpImageView.frame = CGRect(x: (view.width-size)/2, y: 70, width: size, height: size)
        pfpImageView.layer.cornerRadius = pfpImageView.width/2.0
    }
    
    @objc private func changeProfilePicTapped() {
        presentPhotoActionSheet()
    }
    
    // MARK: Action Functions
    
    func setUpElements() {
        // Hides the "Error" Label
        errorLabel.alpha = 0
        
        // Styles the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            // Password isn't secure enough
            return "Please make sure your password has at least 8 characters and contains an uppercase and lowercase letter, a special character, a number"
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields: Checks if all fields are filled in and password is secure
        let error = validateFields()
        
        if error != nil {
            
            // There is an error in the fields, show error message
            showError(error!)
        }
        else {
            
            // Create cleaned versions of the data (strip out all white spaces)
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            spinner.show(in: view)
            
            // Firebase: Create the user
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                
                DispatchQueue.main.async {
                    self.spinner.dismiss()
                }
                
                guard !exists else{
                    // User already exists
                    print("User already exists, errorrrrrrr")
                    self.showError("A user account for that email address already exists")
                    return
                }
                
                Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                    guard authResult != nil, error == nil else{
                        // Error: Stop creation of user
                        print("goes straight to here")
                        self.showError("Error creating user")
                        return
                    }
                    
                    let chatUser = ChatAppUser(firstName: firstName,
                                               lastName: lastName,
                                               emailAddress: email)
                    
                    DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                        if success {
                            guard let image = self.pfpImageView.image,
                                  let data = image.pngData() else {
                                    return
                            }
                            
                            let filename = chatUser.profilePictureFileName
                            StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                                switch result {
                                case .success(let downloadUrl):
                                    UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                    print(downloadUrl)
                                case .failure(let error):
                                    print("Storage manager error: \(error)")
                                }
                            })
                        }
                    })
                    self.transitionToTabBar()
                }
            })
        }
    }
    
    // MARK: Helper Functions
    
    func showError(_ message:String) {
        
        // Makes error message visible
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToTabBar() {
        let homeTabBarController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeTabBarController) as? HomeTabBarController
        
        view.window?.rootViewController = homeTabBarController
        view.window?.makeKeyAndVisible()
    }

    // MARK: Image picker functions
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?" , preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.pfpImageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
