//
//  AddContentViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 27/08/22.
//

import UIKit

class AddContentViewController: UIViewController {
    
    var filenames: [String?] = []

    @IBOutlet weak var typeSelector: UIButton!
    @IBOutlet weak var contentTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFileNames()
        print("DIRECTORY CONTENTS")
        print(filenames)
    }
    
    func getFileNames(){
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else{
            return
        }
        let currDir = url.appendingPathComponent("Transcriptions")
        print("Current Directory is:")
        print(currDir)
        do {
            self.filenames = try manager.contentsOfDirectory(atPath: currDir.path)
        } catch {
            print("An error has occurred in reading directory contents")
        }
    }

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addTapped(_ sender: Any) {
    }
}
