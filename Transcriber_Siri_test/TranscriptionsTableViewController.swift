//
//  TranscriptionsTableViewController.swift
//  Transcriber_Siri_test
//
//  Created by Andrei Palonski on 13.11.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import CoreData

class TranscriptionsTableViewController: UITableViewController {  
  
  var transcriptions: [NSManagedObject] = [NSManagedObject]()
		
  override func viewDidLoad() {
    super.viewDidLoad()
    
    chechPermissions()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    if let result = CoreDataHelper().getTranscriptions() {
      transcriptions = result
    }
    tableView.reloadData()
  }

  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return transcriptions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "transcriptionsTableViewCell", for: indexPath)
    let transc = transcriptions[indexPath.row]
    cell.textLabel?.text = String(describing: transc.value(forKey: "audioFileUrlString"))
    
    // Configure the cell...
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

  //MARK: Permissions
  
  func chechPermissions() {
    let recAuthorised = AVAudioSession.sharedInstance().recordPermission() == .granted
    let transAuthorised = SFSpeechRecognizer.authorizationStatus() == .authorized
    let authorized = recAuthorised && transAuthorised
    if !authorized {
      if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PermissionsVC") {
        self.navigationController?.present(vc, animated: true, completion: nil)
      }
    }
  }
}
