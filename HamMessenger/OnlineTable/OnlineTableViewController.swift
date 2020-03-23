//
//  OnlineTableViewController.swift
//  HamMessanger
//
//  Created by Nicolas Bachschwell on 30.10.19.
//  Copyright © 2019 NBSgamesAT. All rights reserved.
//

import UIKit

class OnlineTableViewController: UITableViewController {
  
  @IBOutlet weak var tableNavItem: UINavigationItem!
  
  var selectedCall: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }

  // MARK: Data is from AppDelegate

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return AppDelegate.peopleOnline.count;
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OnlineTableViewCell", for: indexPath)
    guard let actualCell = cell as? OnlineTableViewCell else {
      fatalError("Could not downgrade the cell");
    }
    let user = AppDelegate.peopleOnline[indexPath.row];
    actualCell.callLabel.text = user.callSign;
    actualCell.nameLabel.text = user.name;
    actualCell.ipLabel.text = user.ip;
    #if targetEnvironment(macCatalyst)
    actualCell.location.text = user.location;
    actualCell.locator.text = user.locator;
    #endif
    return actualCell;
  }
  
  
  public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedCall = AppDelegate.peopleOnline[indexPath.row].callSign
    self.performSegue(withIdentifier: "toPrivMessage", sender: self)
  }
  
  public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toPrivMessage" {
      let cont: PrivateMessageController = segue.destination as! PrivateMessageController
      cont.currentSelectedCall = selectedCall
    }
  }
  

  /*
  // Override to support conditional editing of the table view.
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  */

  /*
  // Override to support editing the table view.
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // Delete the row from the data source
      tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
  }
  */

  /*
  // Override to support rearranging the table view.
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
  }
  */

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
  }
  */

}
