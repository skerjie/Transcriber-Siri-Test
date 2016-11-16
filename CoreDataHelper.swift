//
//  CoreDataHelper.swift
//  Transcriber_Siri_test
//
//  Created by Andrei Palonski on 16.11.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
  
  init() {
    let container = NSPersistentContainer(name: "Transcriber_Siri_test")
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error {
        print(error.localizedDescription + "skrj")
      } else {
        print("Core Data fine! skrj")
      }
    }
  }
  
  func getContext() -> NSManagedObjectContext {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
    
  }
  
  func storeTranscription(audioFileUrl: String, textFileUrl: String) {
    let context = getContext()
    let entity = NSEntityDescription.entity(forEntityName: "Transcription", in: context)
    let transc = NSManagedObject(entity: entity!, insertInto: context)
    transc.setValue(audioFileUrl, forKey: "audioFileUrlString")
    transc.setValue(textFileUrl, forKey: "textFileUrlString")
    
    do {
      try context.save()
      print("skrj Saved in CoreData")
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func getTranscriptions () -> [NSManagedObject]? {
    let fetchRequest: NSFetchRequest<Transcription> = Transcription.fetchRequest()
    do {
      let searchResult = try getContext().fetch(fetchRequest)
      print("skrj \(searchResult.count)")
      for trans in searchResult as [NSManagedObject] {
        print("skrj Result: \(trans.value(forKey: "audioFileUrlString"))")
      }
      return searchResult as [NSManagedObject]
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }

}
