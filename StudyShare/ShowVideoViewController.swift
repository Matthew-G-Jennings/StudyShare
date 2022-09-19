//
//  ShowVideoViewController.swift
//  StudyShare
//
//  this uses the iphone dialog to chose a media from the photo library
//
//  Created by CGi on 26/08/22.
//

import UIKit
import AVKit
import AVFoundation

import MobileCoreServices

class ShowVideoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // choosevideo is the iphone dialog to choose media from the library!
    @IBAction func chooseVideo(_ sender: AnyObject) {
      if UIImagePickerController
          .isSourceTypeAvailable(.savedPhotosAlbum) == false {
        return
      }

      let imgPicker = UIImagePickerController()
      imgPicker.sourceType = .savedPhotosAlbum
      imgPicker.mediaTypes = [kUTTypeMovie  as String]
      imgPicker.delegate = self
      
      // show
      self.present(imgPicker, animated: true, completion: nil)
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
