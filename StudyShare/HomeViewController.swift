//
//  HomeViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 31/07/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Firebase


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var classTable: UITableView!
    //   var groupData : [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUserDetails()
        setUpGroupDetails()
        classTable.dataSource = self
        classTable.delegate = self
        
        self.classTable.register(UITableViewCell.self, forCellReuseIdentifier: "groupCell")
        
        // Do any additional setup after loading the view.
    }
    
    //Get selected element and move to the class content view controller, display more information about it
    
    /**
     Utilizes the classes to retreive their list of classes from the firebase db
     Stores this information in a class dedicated to holding the group info.
     Retrives and stores description, filepath, institution, name, semester and year (firebase reference to this user)
     */
    func setUpGroupDetails(){
        let db = Firestore.firestore()
        let all = User.groups
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
                    
                    let g = Group(Description: group.Description, Filepath: group.Filepath, Institution:group.Institution, Name: group.Name, Semester: group.Semester, Year: group.Year)
                    
                    if(!User.groups.contains(g.Filepath))
                    {
                        continue
                    }
                    
                    User.groupData.append(g)
                }
            }
            DispatchQueue.main.async {
                self.classTable.reloadData()
            }
        }
    }
    
    /**
     - Parameters:
     - value: UITableView: The basic appearance of the cell
     - value: section: Seperates the number of rows into sections
     - Returns: The current count of data in the groupData array
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.groupData.count
    }
    
    /**
     - Parameters:
     - value: UITableView: The basic appearance of the cell
     - value: Indexpath: Represents the path to a specific location
     - Returns: Displays the class name which the user just created to the cell
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        cell.textLabel?.text = User.groupData[indexPath.row].Name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tableView.deselectRow(at: indexPath, animated: true)
        //        let selectedClass = User.groupData[indexPath.row]
        //        let vc = ClassContentViewController()
        //        vc.title = selectedClass.Name
        // self.transitionToClassContent()
    }
    //
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let selectedClass = self.groupData[indexPath.row]
    //        if let viewController = storyboard?.instantiateViewController(identifier: "ClassContentViewController") as? ClassContentViewController {
    //            viewController.class = selectedClass
    //            navigationController?.pushViewController(viewController, animated: true)
    //        }
    //    }
    
    /**
     Utilizes the currently logged in users UID to retreive their full info from firebase db
     Stores this information in a class dedicated to holding the users info.
     Retrives and stores firstname, lastname, documentID(firebase reference to this user)
     */
    func setUpUserDetails(){
        
        if Auth.auth().currentUser != nil{
            let user = Auth.auth().currentUser
            User.UID = user!.uid
            let db = Firestore.firestore()
            let userData = db.collection("users").whereField("uid", isEqualTo: User.UID)
            userData.getDocuments(){ (querySnaphot, err) in
                if let err = err {
                    print("Error retrieving user data: \(err)")
                } else{
                    let document = querySnaphot!.documents[0]
                    let userDataDict = document.data()
                    User.firstName = (userDataDict["firstname"] as! String)
                    User.lastName = (userDataDict["lastname"] as! String)
                    User.docID = document.documentID
                }
            }
        } else {
            // Something has gone horribly wrong
        }
    }
    /*
    func transitionToClassContent(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let classContentController = storyboard.instantiateViewController(withIdentifier: "ClassContentVC")
        print("Class Content Controller is:")
        print(classContentController)
        present(classContentController, animated: true, completion: nil)
    }
    */
}
