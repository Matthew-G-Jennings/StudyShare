//
//  AddContentViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 27/08/22.
//

import UIKit

class AddContentViewController: UIViewController {

    @IBOutlet weak var typeSelector: UIButton!
    @IBOutlet weak var contentTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addTapped(_ sender: Any) {
    }
}
