//
//  UserInfoViewController.swift
//  PartnerUp
//
//  Created by Joshua Chuang on 12/29/20.
//

import UIKit
import FirebaseAuth

class UserInfoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: UI Variables
    @IBOutlet weak var pfpImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var interestsTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!

    
    // MARK: Loading Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    // Presents the photo action sheet pop-up
    @objc private func changeProfilePicTapped() {
        presentPhotoActionSheet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.width/3
        pfpImageView.frame = CGRect(x: (view.width-size)/2, y: 150, width: size, height: size)
        pfpImageView.layer.cornerRadius = pfpImageView.width/2.0
        applyProfilePicture()
    }
    
    
    
    // MARK: Action Functions
    
    // Logs user out
    @IBAction func logoutTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Log Out",
                                            message: "Are you sure you want to log out?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Confirm",
                                      style: .destructive,
                                      handler: {  _ in
                                        do {
                                            try Auth.auth().signOut()
                                            let viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.viewController) as! ViewController
                                            let appDelegate = UIApplication.shared.delegate
                                            appDelegate?.window??.rootViewController = viewController
                                        }
                                        catch {
                                            print("Failed to log out")
                                        }
                        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        present(actionSheet, animated: true)
    }
    

    // MARK: Helper Functions
    func setUpElements() {
        // Style the elements
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(bioTextField)
        Utilities.styleTextField(interestsTextField)
        Utilities.styleFilledButton(saveButton)
        Utilities.styleHollowButton(logoutButton)
    }

    func applyProfilePicture(){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                self.downloadImage(imageView: self.pfpImageView, url: url)
                
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
    }
    
    // Downloads the current user's profile picture from Firebase and uploads it as the profile picture
    func downloadImage(imageView: UIImageView, url: URL){
        URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }).resume()
    }
    
    // MARK: Photo Presenting Helper Functions
    
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
