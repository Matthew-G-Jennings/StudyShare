//
//  SignUpViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 31/07/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        // make the keyboard disappear, when click outside fields
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    /**
    Validates the fields are correct
    Returns: String: Contains the error message if an error occurred, otherwise nil
    */
    func validateFields() -> String? {
        // Check all fields have data
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        // Check if the password meets security standards
        let passwordClean = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(passwordClean) == false {
            return "Password must contain at least 8 characters, a number and a symbol"
        }
        return nil
    }
    
    /**
    Attempts to create the user given the information supplied
    If successful will transition to the home screen with this user logged in.
    */
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate fields
        let error = validateFields()
        
        if error != nil {
            // We have an error
            showError(error!)
        } else {
            // Create cleaned versions of fields
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // Check for errors
                if err != nil {
                    // We have an error
                    let errorMessage = err?.localizedDescription.description
                    self.showError(errorMessage!)
                } else {
                    // Success
                    let database = Firestore.firestore()
                    let groups = ["INIT"]
                    database.collection("users").addDocument(data: ["firstname": firstname,
                                                              "lastname": lastname,
                                                              "uid": result!.user.uid,
                                                              "groups": groups]
                                                              ) { (error) in
                        if error != nil {
                            // There was an error
                            self.showError("Could not connect to database, user data not stored")
                        }
                    }
                    // Move to home screen
                    self.transitionToHome()
                }
            }
        }
    }
    
    /**
    Displays an error in the UI label
    - Parameters:
            - message: String: The error message to display
    */
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    /**
    Instantiates a home screen view controller and transitions to it.
    */
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

}
