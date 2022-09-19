//
//  ShowNotesViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 26/08/22.
//

import UIKit

class ShowNotesViewController: UIViewController {

    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var notesTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func likeButtonTapped(_ sender: Any) {
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
