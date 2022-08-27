//
//  AddContentViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 27/08/22.
//

import UIKit
import FirebaseStorage

class AddContentViewController: UIViewController {
    
    var filenames: [String?] = []
    var selectedFile: String = ""
    var previousSelection = 0

    @IBOutlet weak var typeSelector: UIButton!
    @IBOutlet weak var contentTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFileNames()
        contentTable.delegate = self
        contentTable.dataSource = self
        self.contentTable.register(UITableViewCell.self, forCellReuseIdentifier: "groupCell")
    }
    
    func getFileNames(){
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else{
            return
        }
        let currDir = url.appendingPathComponent("Transcriptions")
        do {
            self.filenames = try manager.contentsOfDirectory(atPath: currDir.path)
        } catch {
            print("An error has occurred in reading directory contents")
        }
    }

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /**
        The add button has been tapped, confirm a file is selected and if so upload it to the firebase storage for this class
     */
    @IBAction func addTapped(_ sender: Any) {
        if (selectedFile.count > 0){
            let manager = FileManager.default
            guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else{
                return
            }
            let pathToFile = url.path.trimmingCharacters(in: .whitespacesAndNewlines) + "/" + User.currentGroup.trimmingCharacters(in: .whitespacesAndNewlines) + "/ " + selectedFile.trimmingCharacters(in: .whitespacesAndNewlines)
            print("PATH TO FILE")
            print(pathToFile)
            let fileToUpload = URL(string: pathToFile)
            print("URL TO FILE")
            print(fileToUpload)
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let targetDir = User.currentGroup + "/" + selectedFile
            let targetRef = storageRef.child(targetDir)
            
            let uploadTask = targetRef.putFile(from: fileToUpload!, metadata: nil){ metadata, error in
                guard let metadata = metadata else {
                    print("Error uploading file")
                    return
                }
                let size = metadata.size
                targetRef.downloadURL{ (url, error) in
                    guard let downloadURL = url else {
                        print("Error uploading file")
                        return
                    }
                }
            }
        } else {
            print("Please select a file")
            return
        }
    }
}

extension AddContentViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let prevPath = IndexPath(arrayLiteral: 0, previousSelection)
        tableView.cellForRow(at: prevPath)?.setHighlighted(false, animated: true)
        tableView.cellForRow(at: indexPath)?.setHighlighted(true, animated: true)
        previousSelection = indexPath.row
        selectedFile = filenames[previousSelection]!
    }
}

extension AddContentViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filenames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentTable.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        cell.textLabel?.text = self.filenames[indexPath.row]
        return cell
    }
}
