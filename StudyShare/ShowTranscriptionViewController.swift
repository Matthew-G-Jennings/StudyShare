//
//  ShowTranscriptionViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 26/08/22.
//

import UIKit

class ShowTranscriptionViewController: UIViewController {

    @IBOutlet weak var transcriptionTitle: UILabel!
    @IBOutlet weak var transcriptionView: UITextView!
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