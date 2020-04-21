//
//  AppDelegate.swift
//  te
//
//  Created by Nicolas Bachschwell on 06.08.19.
//  Copyright © 2019 NBSgamesAT. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
  
  static var messageView: UITableView?
  var idb: DBMan?
  static var privateMessageView: PrivateMessageController?
  
  var window: UIWindow?
  
  static var con: TCPController?
  var privateSplit: PrivateSplitViewController?
  var tableController: UITableViewController?;
  var onlineHandler: OnlineHandler?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    SettingsManager.registerSettingsBundle()
    do{
      self.idb = try DBMan();
    }
    catch {
      print("NO DATABASE AVAILABLE")
    }
    if(UserDefaults.standard.bool(forKey: "hasValues")){
      #if targetEnvironment(macCatalyst)
        let board = UIStoryboard.init(name: "Mac", bundle: nil)
        let controller = board.instantiateInitialViewController()
        window?.rootViewController = controller;
        window?.makeKeyAndVisible()
      #endif
      privateSplit = window?.rootViewController as? PrivateSplitViewController
      //tableController = ((privateSplit?.viewControllers[0] as! UITabBarController).viewControllers![0] as! UINavigationController).viewControllers[0] as? UITableViewController
      //_ = privateSplit?.viewControllers[0] as! UITabBarController
      //_ = (privateSplit?.viewControllers[0] as! UITabBarController).viewControllers![0] as! UINavigationController
      tableController = ((privateSplit?.viewControllers[0] as! UITabBarController).viewControllers![0] as! UINavigationController).viewControllers[0] as? UITableViewController
      self.openConnection(tableController: tableController!);
    }
    else{
      let board = UIStoryboard.init(name: "FirstStart", bundle: nil)
      let controller = board.instantiateInitialViewController()
      window?.rootViewController = controller;
      window?.makeKeyAndVisible()
    }
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    AppDelegate.con?.stopListenerWithOfflineMessage()
    AppDelegate.con = nil
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    let url = UserDefaults.standard.value(forKey: "server") as? String ?? "44.143.0.1"
    AppDelegate.con = TCPController(url, port: 9124, eventHandler: self.onlineHandler!)
    AppDelegate.con?.activateListener()
    
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    self.closeConnection();
  }
  
  func openConnection(tableController: UITableViewController){
    if(AppDelegate.con == nil || AppDelegate.con!.giveUp){
      let url = UserDefaults.standard.value(forKey: "server") as? String ?? "44.143.0.1"
      self.onlineHandler = OnlineHandler(tableController: tableController)
      AppDelegate.con = TCPController(url, port: 9124, eventHandler: self.onlineHandler!)
      AppDelegate.con?.activateListener();
    }
  }
  func closeConnection(){
    if(AppDelegate.con != nil && !AppDelegate.con!.giveUp){
      AppDelegate.con?.stopListenerWithOfflineMessage();
    }
  }
  
  static func getAppDelegate() -> AppDelegate{
    let delegate = UIApplication.shared.delegate as! AppDelegate
    return delegate;
  }
}

