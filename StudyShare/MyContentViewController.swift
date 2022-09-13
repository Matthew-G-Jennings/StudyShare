//
//  MyContentViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 13/09/22.
//

import UIKit

class MyContentViewController: UIViewController {
    
    var filenames: [String?] = []
    var selectedFile: String = ""
    var previousSelection = 0

    @IBOutlet weak var contentTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getFileNames()
        contentTable.delegate = self
        contentTable.dataSource = self
        self.contentTable.register(UITableViewCell.self, forCellReuseIdentifier: "groupCell")

        // Do any additional setup after loading the view.
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
            print("An error has occurred in reading directory contents")
        }
    }

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     - Parameters:
     - value:segue: The segue object containing information about the view controllers involved in the segue.
     - value: sender: The object that initiated the segue.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "localtranscription" {
            if let indexPath = contentTable.indexPathForSelectedRow {
                let nextViewController = segue.destination as! ShowTranscriptionViewController
                nextViewController.filepath = "Local"
                nextViewController.remote = false
                nextViewController.filename = filenames[previousSelection]
            }
        }
    }
    

}
extension MyContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        previousSelection = indexPath.row
        performSegue(withIdentifier: "localtranscription", sender: nil)
    }
}

extension MyContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filenames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentTable.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        cell.textLabel?.text = self.filenames[indexPath.row]
        return cell
    }
}
