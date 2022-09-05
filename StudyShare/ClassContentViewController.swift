//
//  ClassContentViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 24/08/22.
//

import UIKit
import FirebaseStorage

class ClassContentViewController: UIViewController {
    var name: String?
    var filepath: String?
    var filenames: [String?] = []
    var previousSelection = -1
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var contentTable: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        classNameLabel.text = name
        getFileNames()
        contentTable.dataSource = self
        contentTable.delegate = self
        self.contentTable.register(UITableViewCell.self, forCellReuseIdentifier: "contentCell")
        // Do any additional setup after loading the view.
    }
    
    func getFileNames() {
        let storage = Storage.storage()
        let storageRef = storage.reference().child(filepath!)
        var filenames: [String?] = []
        storageRef.listAll {(result, error) in
            if let error = error {
                print(error)
            }
            for item in result!.items {
                filenames.append(item.name)
            }
            self.filenames = filenames
            DispatchQueue.main.async {
                self.contentTable.reloadData()
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ClassContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        previousSelection = indexPath.row
        performSegue(withIdentifier: "transcriptiontrans", sender: nil)
    }
    /**
     - Parameters:
     - value:segue: The segue object containing information about the view controllers involved in the segue.
     - value: sender: The object that initiated the segue.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transcriptiontrans" {
            if let indexPath = contentTable.indexPathForSelectedRow {
                let nextViewController = segue.destination as! ShowTranscriptionViewController
                nextViewController.filepath = filepath
                nextViewController.filename = filenames[previousSelection]
            }
        }
    }
}

extension ClassContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filenames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
        cell.textLabel?.text = filenames[indexPath.row]
        return cell
    }
}
