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
        errorLabel.alpha = 1

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
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
            let dirName = name + "_" + year + "_" + semesterField.text!
            
            let storage = Storage.storage()
            
        }
    }
    
    func validateFields() -> String?{
        if !paperCodeField.hasText{
            return "Please fill out name"
        }
        if !paperDescField.hasText{
            return "Please fill out description"
        }
        if !yearField.hasText{
            return "Please fill out year"
            let yearNum = Int(yearField.text!) ?? 0
            let currYear = Calendar.current.component(.year, from: Date())
            if yearNum != currYear && yearNum != currYear + 1{
                return "Year must be this year or next year"
            }
        }
        if !semesterField.hasText{
            return "Please fill out semester"
            let semNum = Int(semesterField.text!) ?? 0
            if semNum != 1 && semNum != 2{
                return "Semester must be 1 or 2"
            }
        }
        if !institutionField.hasText{
            return "Please fill out institution"
            // TODO: Validate this a valid institution
        }
        //TODO: Add more validation, prevent duplicates by checking db for existing name+year+sem combo
        return nil
    }
}
