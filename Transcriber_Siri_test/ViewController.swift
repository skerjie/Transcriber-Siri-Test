//
//  ViewController.swift
//  Transcriber_Siri_test
//
//  Created by Andrei Palonski on 13.11.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController {
  
  @IBOutlet weak var button: UIButton!
  
  @IBOutlet weak var label: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  // получение прав на доступ к микрофону и запись
  func requestRecordPermissions() {
    AVAudioSession.sharedInstance().requestRecordPermission() {
      [unowned self] allowed in
      DispatchQueue.main.async {
        if allowed {
          // get transcription permissions
          self.requestTranscribePermissions()
        } else {
          // error
          self.showError()
        }
      }
    }
  }
  
  // получение прав на распознование речи
  func requestTranscribePermissions() {
    SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
      DispatchQueue.main.async {
        if authStatus == .authorized {
          // great good to go!
          self.dismiss(animated: true, completion: nil)
        } else {
          // error handling
          self.showError()
        }
      }
    }
  }
  
  func showError() {
    self.label.text = "You have previously denied this app acces to speech recognition. Please change in settings and restart the app!"
  }
  
  func disableButton() {
    self.button.isEnabled = false
    UIView.animate(withDuration: 1.0) { // делаем в клоужере анимацию становления кнопки не активной
      self.button.alpha = 0.3
    }
  }
  
  @IBAction func buttonClecked(_ sender: Any) {
    requestRecordPermissions()
  }

}

