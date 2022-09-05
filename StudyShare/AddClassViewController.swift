//
//  AddClassViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 7/08/22.
//

import UIKit
import FirebaseFirestore

class AddClassViewController: UIViewController {
    var groups: [Group?] = []
    var previousSelection = -1
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var filterField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroups()
        searchTable.dataSource = self
        searchTable.delegate = self
        self.searchTable.register(UITableViewCell.self, forCellReuseIdentifier: "groupCell")
    }
    
    func getGroups() {
        let database = Firestore.firestore()
        database.collection("classes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error retrieving user data: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let groupsDataDict = document.data()
                    var group = Group()
                    group.description   = (groupsDataDict["Description"] as? String ?? "")
                    group.filepath = (groupsDataDict["Filepath"] as? String ?? "")
                    group.institution = (groupsDataDict["Institution"] as? String ?? "")
                    group.name = (groupsDataDict["Name"] as? String ?? "")
                    group.semester = (groupsDataDict["Semester"] as? String ?? "")
                    group.year = (groupsDataDict["Year"] as? String ?? "")
                    let groupVar = Group(description: group.description, filepath: group.filepath, institution: group.institution, name: group.name, semester: group.semester, year: group.year)
                    
                    self.groups.append(groupVar)
                }
            }
            DispatchQueue.main.async {
                self.searchTable.reloadData()
            }
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        if previousSelection >= 0 {
            let database = Firestore.firestore()
            let dirName = groups[previousSelection]!.filepath
            let userRef = database.collection("users").document(User.docID)
            userRef.updateData(["groups": FieldValue.arrayUnion([dirName])])
            User.groups.append(dirName)
            self.transitionToHome()
            
        } else {
            print("Please make a selection")
        }
    }
    
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

extension AddClassViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prevPath = IndexPath(arrayLiteral: 0, previousSelection)
        tableView.cellForRow(at: prevPath)?.setHighlighted(false, animated: true)
        tableView.cellForRow(at: indexPath)?.setHighlighted(true, animated: true)
        previousSelection = indexPath.row
    }
}

extension AddClassViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTable.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        cell.textLabel?.text = groups[indexPath.row]?.filepath
        return cell
    }
}
