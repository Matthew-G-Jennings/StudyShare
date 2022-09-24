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

    var existingGroups: [String?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        getExistingGroups()
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
            showError(error!)
        } else {
            let name = paperCodeField.text!.uppercased()
            let desc = paperDescField.text!
            let year = yearField.text!
            let sem = semesterField.text!
            let instit = institutionField.text!
            let dirName = name + "_" + yearField.text! + "_" + semesterField.text!

            let database = Firestore.firestore()
            database.collection("classes").addDocument(data: ["Name": name,
                                                        "Description": desc,
                                                        "Year": year,
                                                        "Semester": sem,
                                                        "Institution": instit,
                                                        "Filepath": dirName]) { (error) in
                if error != nil {
                    // There was an error
                    self.showError("Could not connect to database, class not created")
                }
            }
            let metaRef = database.collection("meta").document("groups")
            metaRef.updateData(["fullname": FieldValue.arrayUnion([dirName])])
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
     Gets the identifiers for the groups that currently exist and stores them in
     an array.
     Used to ensure uniqueness and prevent duplicate groups
     */
    func getExistingGroups() {
        let database = Firestore.firestore()
        let groupRef = database.collection("meta").document("groups")
        groupRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.existingGroups = document.data()!["fullname"] as! [String?]
            } else {
                print("Error communicating with database")
            }
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
        }
        let sem = semesterField.text!
        if sem != "1" && sem != "2" && sem != "SS" && sem != "FY" {
            return "Semester must be 1, 2, SS or FY"
        }
        let yearNum = Int(yearField.text!) ?? 0
        let currYear = Calendar.current.component(.year, from: Date())
        if yearNum != currYear && yearNum != currYear + 1 {
            return "Year must be this year or next year"
        }
        let paperCode = paperCodeField.text!
        if paperCode.count != 7 {
            return "Paper code must be in the format COSC345"
        }
        // This should probably be replaced with regex at some point
        var strindex = 0
        for char in paperCode {
            if !char.isLetter && strindex < 4 {
                return "Paper code must be in the format COSC345"
            } else if !char.isNumber && strindex >= 4 {
                return "Paper code must be in the format COSC345"
            }
            strindex += 1
        }
        let newName = paperCodeField.text!.uppercased() + "_" + yearField.text! + "_" + semesterField.text!
        for fullName in existingGroups {
            if newName == fullName {
                return "This paper already exists for this year/semester"
            }
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
