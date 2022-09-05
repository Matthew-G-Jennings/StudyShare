//
//  ShowTranscriptionViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 26/08/22.
//

import UIKit
import FirebaseStorage

class ShowTranscriptionViewController: UIViewController {
    var filepath: String?
    var filename: String?
    @IBOutlet weak var transcriptionTitle: UILabel!
    @IBOutlet weak var transcriptionView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        transcriptionTitle.text = filename
        loadFileToText()
        // Do any additional setup after loading the view.
    }
    
    func loadFileToText() {
        let storage = Storage.storage()
        let path = filepath! + "/" + filename!
        let pathRef = storage.reference(withPath: path)
        pathRef.getData(maxSize: 4 * 1024 * 1024) {data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.transcriptionView.text = String(decoding: data!, as: UTF8.self)
            }
        }
        
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
