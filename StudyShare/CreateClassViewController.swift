//
//  CreateClassViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 19/08/22.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Firebase

class CreateClassViewController: UIViewController {
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var paperCodeField: UITextField!
    @IBOutlet weak var paperDescField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var semesterField: UITextField!
    @IBOutlet weak var institutionField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
    }
    
    /**
    Attempts to create a new class given the provided information.
    Sets up this class in firebase and in local static User.swift
    If successful will also initialize a directory in firestore for this classes
    content.
    */
    @IBAction func createButtonTapped(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            errorLabel.text = error
        } else {
            let name = paperCodeField.text!
            let desc = paperDescField.text!
            let year = Int(yearField.text!)
            let sem = Int(semesterField.text!)
            let instit = institutionField.text!
            let dirName = name + "_" + yearField.text! + "_" + semesterField.text!
            
            let database = Firestore.firestore()
            database.collection("classes").addDocument(data: ["Name": name,
                                                        "Description": desc,
                                                        "Year": String(year!),
                                                        "Semester": String(sem!),
                                                        "Institution": instit,
                                                        "Filepath": dirName]) { (error) in
                if error != nil {
                    // There was an error
                    self.showError("Could not connect to database, class not created")
                }
            }
            let storerr = initStorage(dirName)
            if storerr != nil {
                showError(storerr!)
            } else {
                
            }
            let userRef = database.collection("users").document(User.docID)
            userRef.updateData(["groups": FieldValue.arrayUnion([dirName])])
            User.groups.append(dirName)
            self.transitionToHome()
        }
    }
    
    /**
    Validates the fields are free from errors
        -Returns: String containing the error message if an error occured, otherwise nil
    */
    func validateFields() -> String? {
        if !paperCodeField.hasText {
            return "Please fill out name"
        }
        if !paperDescField.hasText {
            return "Please fill out description"
        }
        if !yearField.hasText {
            return "Please fill out year"
        }
        if !semesterField.hasText {
            return "Please fill out semester"
        }
        if !institutionField.hasText {
            return "Please fill out institution"
            // TODO: Validate this a valid institution
        }
        //TODO: Add more validation, prevent duplicates by checking db for existing name+year+sem combo
        let semNum = Int(semesterField.text!) ?? 0
        if semNum != 1 && semNum != 2 {
            return "Semester must be 1 or 2"
        }
        let yearNum = Int(yearField.text!) ?? 0
        let currYear = Calendar.current.component(.year, from: Date())
        if yearNum != currYear && yearNum != currYear + 1 {
            return "Year must be this year or next year"
        }
        return nil
    }
    
    /**
    Displays the provided error message in error UI label
    -Parameters:
        - message: String: The error message to display
    */
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    /**
    Initializes the firebase storage.
    Should only be called from createButtonTapped and after full validation.
        -Returns: String: The error message if an error occurred, otherwise nil
    */
    func initStorage(_ filePath: String) -> String? {
        let data: Data? = "init".data(using: .utf8)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let classStorageLoc = storageRef.child(filePath + "/temp.txt")
        classStorageLoc.putData(data!)
        return nil
    }
    
    /**
    Dismisses this screen if the back button is tapped
    */
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
    Instantiates and transitions to the home view controller.
    Necessary to force reloading of the class data.
    */
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
