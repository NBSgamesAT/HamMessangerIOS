//
//  OnlineHandler.swift
//  HamMessanger
//
//  Created by Nicolas Bachschwell on 11.11.19.
//  Copyright © 2019 NBSgamesAT. All rights reserved.
//

import Foundation
import UIKit

class OnlineHandler: TCPEventHandler{
  
  var tableController: UITableViewController;
  
  init(tableController: UITableViewController){
    self.tableController = tableController;
  }
  
  func onReceive(_ message: HamMessage){
    //print("HA")
    if(message.contact == "CQ" && message.payloadString.split(separator: "\t").count == 5){
      //print("HA")
      let info = message.payloadString.split(separator: "\t");
      if(info[4] == "CLOSE"){
        AppDelegate.peopleOnline.removeAll { (callInformation) -> Bool in
          return message.source == callInformation.callSign
        }
      }
      else{
        if(!OnlineHandler.arrayContainInfo(array: &AppDelegate.peopleOnline, call: message.source)){
          DispatchQueue.main.async {
            (self.tableController.view as! UITableView).beginUpdates();
            AppDelegate.peopleOnline.append(OnlineCall(callSign: message.source, name: String(info[0]), ip: String(info[2])))
            (self.tableController.view as! UITableView).insertRows(at: [IndexPath(row: AppDelegate.peopleOnline.count - 1, section: 0)], with: UITableView.RowAnimation.none);
            (self.tableController.view as! UITableView).endUpdates();
          }
          
          
        }
      }
    }
    else{
      
    }
  }
  
  static func arrayContainInfo(array: inout [OnlineCall], call: String) -> Bool {
    for checkfor in array {
      if checkfor.callSign == call {
        return true;
      }
    }
    return false;
  }
  
}