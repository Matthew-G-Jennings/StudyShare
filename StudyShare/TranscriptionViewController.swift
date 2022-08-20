//
//  TranscriptionViewController.swift
//  StudyShare
//
//  Created by Matthew Jennings on 7/08/22.
//

import UIKit
import Speech
import AVKit

class TranscriptionViewController: UIViewController {

    
    @IBOutlet weak var transcriptionText: UITextView!
    @IBOutlet weak var beginButton: UIButton!
    
    let speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: "en-NZ"))
    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask         : SFSpeechRecognitionTask?
    let audioEngine             = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func setupSpeech() {

        self.beginButton.isEnabled = false
        //self.speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in

            var isButtonEnabled = false

            switch authStatus {
            case .authorized:
                isButtonEnabled = true

            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")

            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")

            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            @unknown default:
                fatalError()
            }

            OperationQueue.main.addOperation() {
                self.beginButton.isEnabled = isButtonEnabled
            }
        }
    }

    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true

        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in

            var isFinal = false

            if result != nil {

                self.transcriptionText.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.beginButton.isEnabled = true
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        self.audioEngine.prepare()

        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }

        self.transcriptionText.text = "Say something, I'm listening!"
    }
    
    @IBAction func beginButtonTapped(_ sender: Any) {
        // User has tapped the "Begin Transcription" button
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.beginButton.isEnabled = false
            self.beginButton.setTitle("Start Recording", for: .normal)
        } else {
            self.startRecording()
            self.beginButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        // User has tapped the save button
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TranscriptionViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.beginButton.isEnabled = true
        } else {
            self.beginButton.isEnabled = false
        }
    }
}
