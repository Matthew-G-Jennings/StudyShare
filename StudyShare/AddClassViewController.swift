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
    
    func getGroups(){
        let db = Firestore.firestore()
        db.collection("classes").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error retrieving user data: \(err)")
            } else{
                for document in querySnapshot!.documents {
                    let groupsDataDict = document.data()
                    var group = Group()
                    group.Description   = (groupsDataDict["Description"] as? String ?? "")
                    group.Filepath = (groupsDataDict["Filepath"] as? String ?? "")
                    group.Institution = (groupsDataDict["Institution"] as? String ?? "")
                    group.Name = (groupsDataDict["Name"] as? String ?? "")
                    group.Semester = (groupsDataDict["Semester"] as? String ?? "")
                    group.Year = (groupsDataDict["Year"] as? String ?? "")
                    let g = Group(Description: group.Description, Filepath: group.Filepath, Institution: group.Institution, Name: group.Name, Semester: group.Semester, Year: group.Year)
                    
                    self.groups.append(g)
                }
            }
            DispatchQueue.main.async {
                self.searchTable.reloadData()
            }
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        if (previousSelection >= 0){
            let db = Firestore.firestore()
            let dirName = groups[previousSelection]!.Filepath
            let userRef = db.collection("users").document(User.docID)
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
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    
}

extension AddClassViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prevPath = IndexPath(arrayLiteral: 0, previousSelection)
        tableView.cellForRow(at: prevPath)?.setHighlighted(false, animated: true)
        tableView.cellForRow(at: indexPath)?.setHighlighted(true, animated: true)
        previousSelection = indexPath.row
    }
}

extension AddClassViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTable.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        cell.textLabel?.text = groups[indexPath.row]?.Filepath
        return cell
    }
}

