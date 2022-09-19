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
    var contentVC: ClassContentViewController?

    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var typeSelector: UIButton!
    @IBOutlet weak var contentTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackLabel.alpha = 0
        getFileNames()
        contentTable.delegate = self
        contentTable.dataSource = self
        self.contentTable.register(UITableViewCell.self, forCellReuseIdentifier: "groupCell")
    }

    func getFileNames() {
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let currDir = url.appendingPathComponent("Transcriptions")
        do {
            self.filenames = try manager.contentsOfDirectory(atPath: currDir.path)
        } catch {
            showLabel("An error has occurred in reading directory contents", true)
        }
    }
    
    /**
    Sets label to the given String
     - Parameters:
            - message: String: The message to display
            - error: Bool True if this is an error, False if feedback
    */
    func showLabel(_ message: String, _ error: Bool) {
        if error {
            feedbackLabel.textColor = UIColor.red
        } else {
            feedbackLabel.textColor = UIColor.green
        }
        feedbackLabel.text = message
        feedbackLabel.alpha = 1
    }

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /**
        The add button has been tapped, confirm a file is selected and if so upload it to the firebase storage for this class
     */
    @IBAction func addTapped(_ sender: Any) {
        if selectedFile.count > 0 {
            let manager = FileManager.default
            guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            let pathToFile = "file://" + url.path.trimmingCharacters(in: .whitespacesAndNewlines) + "/" + "Transcriptions" + "/" + selectedFile.trimmingCharacters(in: .whitespacesAndNewlines)
            let fileToUpload = URL(string: pathToFile)!
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let targetDir = User.currentGroup + "/" + selectedFile
            let targetRef = storageRef.child(targetDir)
            if (!manager.fileExists(atPath: fileToUpload.path)) {
                showLabel("Failed to read file", true)
            }
            _ = targetRef.putFile(from: fileToUpload)
            showLabel("Uploaded successfully", false)
            contentVC?.newFileAdded(selectedFile.trimmingCharacters(in: .whitespacesAndNewlines))
            
        } else {
            showLabel("Please select a file", true)
            return
        }
    }
}

extension AddContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        previousSelection = indexPath.row
        selectedFile = filenames[previousSelection]!
    }
}

extension AddContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filenames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentTable.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        cell.textLabel?.text = self.filenames[indexPath.row]
        return cell
    }
}
