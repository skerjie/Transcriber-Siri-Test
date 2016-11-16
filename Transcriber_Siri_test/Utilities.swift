//
//  Utilities.swift
//  Transcriber_Siri_test
//
//  Created by Andrei Palonski on 14.11.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import Foundation


class Utilities {
  
  var dateTimeString: String?
  
  func getDocsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docsDirect = paths[0]
    return docsDirect
  }
  
  func getAudioFileUrl () -> URL? {
    
    do {
      let audioURL = try getDocsDirectory().appendingPathComponent(getDateAndTime() + ".m4a")
      return audioURL
    } catch _ {
      return nil
    }
  }
  
  func getTextFileUrl () -> URL? {
    
    do {
      let textURL = try getDocsDirectory().appendingPathComponent(getDateAndTime() + ".txt")
      return textURL
    } catch _ {
      return nil
    }
  }
  
  func getDateAndTime() -> String {
    if let dateT = dateTimeString {
      return dateT
    }
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
    let timeString = formatter.string(from: date)
    return timeString
  }
  
}
