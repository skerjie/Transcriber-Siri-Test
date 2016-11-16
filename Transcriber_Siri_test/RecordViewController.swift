//
//  RecordViewController.swift
//  Transcriber_Siri_test
//
//  Created by Andrei Palonski on 14.11.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
  
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var audioRec: AVAudioRecorder?
  var recFileUrl: URL!
  var textFileUrl : URL!
  var audioPlayer : AVAudioPlayer?
  var recorded: Bool = false
  var transcribed: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    let utils = Utilities()
    recFileUrl = utils.getAudioFileUrl()
    textFileUrl = utils.getTextFileUrl()
    print("skerj" + recFileUrl!.absoluteString)
    recordAudio()
  }

  //MARK Audio-Recording (настройка звука)
  
  @IBAction func stopButtonClicked(_ sender: UIButton) {
    audioRec?.stop()
    sender.titleLabel?.text = "Record finished"
    sender.isEnabled = false
    sender.alpha = 0.2
    activityIndicator.stopAnimating()
    UIView.animate(withDuration: 1.2) {
      self.activityIndicator.alpha = 0.0
    }
  }
  
  
  func recordAudio() {
    let session = AVAudioSession.sharedInstance()
    
    do {
      try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
      try session.setActive(true)
      
      let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 44100,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
      ]
      
      audioRec = try AVAudioRecorder(url: recFileUrl, settings: settings)
      audioRec?.delegate = self
      audioRec?.record()
      activityIndicator.startAnimating()
    } catch let error {
      print("skrj Failed recording \(error)")
      recordingEnded(succed: false)
    }
  }
  
  func recordingEnded(success: Bool) {
    audioRec?.stop()
    if success {
      do {
        //play and transcribe audio
        recorded = true
        audioPlayer?.stop()
        audioPlayer = try AVAudioPlayer(contentsOf: recFileUrl)
        audioPlayer?.play()
        print("skrj Playing...")
      } catch let error {
        print(error)
      }
    }
  }
  
  //MARK Audio-Delegate
  
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if !flag {
      recordingEnded(succed: false)
    } else {
      recordingEnded(succed: true)
    }
  }
  
  func recordingEnded(succed: Bool) {
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    audioPlayer?.stop()
    if transcribed {
      CoreDataHelper().storeTranscription(audioFileUrl: String(describing: recFileUrl), textFileUrl: String(describing: textFileUrl))
    }
  }
  
  //MARK Transcribe
  
  func transcribeAudio() {
    let recognizer = SFSpeechRecognizer()
    let request = SFSpeechURLRecognitionRequest(url: recFileUrl)
    
    recognizer?.recognitionTask(with: request) {
      [unowned self] (result, error) in
      guard let result = result else {
        print("skrj \(error?.localizedDescription)")
        return
      }
      if result.isFinal {
        let text = result.bestTranscription.formattedString
        self.textView.text = text
        do {
          try text.write(to: self.textFileUrl, atomically: true, encoding: String.Encoding.utf8)
          self.transcribed = true
        } catch {
          
        }
      }
    }
  }
}
