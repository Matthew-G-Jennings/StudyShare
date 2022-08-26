//
//  ClassContentViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 24/08/22.
//

import UIKit

class ClassContentViewController: UIViewController {
    
//    private let classes: [String]
    
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var contentTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return User.groupData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
//        cell.textLabel?.text = User.groupData[indexPath.row].Name
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        print(User.groupData[indexPath.row])
//
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
