//
//  ClassContentViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 24/08/22.
//

import UIKit
import FirebaseStorage

class ClassContentViewController: UIViewController {
    
    var name : String?
    var filepath : String?
    var filenames: [String?] = []
    
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var contentTable: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classNameLabel.text = name
        self.filenames = getFileNames()
        // Do any additional setup after loading the view.
    }
    
    func getFileNames() -> [String?]{
        let storage = Storage.storage()
        let storageRef = storage.reference().child(filepath!)
        var filenames: [String?] = []
        storageRef.listAll {(result, error) in
            if let error = error {
                print(error)
            }
            for item in result!.items{
                filenames.append(item.name)
            }
            print("FILENAMES")
            print(filenames)
        }
        return filenames
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
