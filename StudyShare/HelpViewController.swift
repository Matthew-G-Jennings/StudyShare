//
//  HelpViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 7/10/22.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextView!
    var helpText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
