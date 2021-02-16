//
//  LoginViewController.swift
//  PartnerUp
//
//  Created by Joshua Chuang on 12/24/20.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
    
    // MARK: Variables
    
    private let spinner = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: Loading Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureViewComponents()
        setUpElements()
    }
    
    
    // MARK: Action Functions
    
    func setUpElements() {
        // Hide the "Error" label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        
        return nil
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // Validate text fields
        let error = validateFields()
        
        if error != nil {
            self.showError(error!)
        }
        
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        spinner.show(in: view)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, err) in
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            
            guard let result = authResult, error == nil else {
                //Check for errors, could not sign in
                self.showError("Invalid email address or password")
                print("Failed to log in user with email: \(email)")
                return
            }
            
            let user = result.user
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
                switch result {
                case .success(let data):
                    guard let userData = data as? [String: Any],
                          let firstName = userData["first_name"] as? String,
                          let lastName = userData["last_name"] as? String else {
                        return
                    }
                    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
                    
                case .failure(let error):
                    print("Failed to read data with error \(error)")
                }
            })
            
            UserDefaults.standard.set(email, forKey: "email")
            
            print("Logged In User: \(user)")
            self.transitionToTabBar()
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
    
    func transitionToSignUp() {
        let signUpViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.signUpViewController) as? SignUpViewController
        
        view.window?.rootViewController = signUpViewController
        view.window?.makeKeyAndVisible()
    }
}
