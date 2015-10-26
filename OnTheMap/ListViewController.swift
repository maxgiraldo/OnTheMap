//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Maximilian A. Giraldo on 10/23/15.
//  Copyright © 2015 Maximilian A. Giraldo. All rights reserved.
//

import UIKit

let reuseIdentifier = "studentCell"

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  let storyboardId = "InformationPosting"
  @IBOutlet weak var tableView: UITableView!
  var userLocations: [UserLocation] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    getUserLocations()
  }
  
  //MARK: - Actions
  
  @IBAction func reloadBarButtonItemTapped(sender: AnyObject) {
    getUserLocations()
  }
  
  @IBAction func setLocationBarButtonItemTapped(sender: AnyObject) {
    let informationPostingViewController = self.storyboard!.instantiateViewControllerWithIdentifier(storyboardId) as! InformationPostingViewController
    self.presentViewController(informationPostingViewController, animated: true, completion: nil)
  }
  
  @IBOutlet weak var logoutBarButtonItemTapped: UIBarButtonItem!
  
  //MARK: - UITableView data source
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
    let user = userLocations[indexPath.row]
    
    cell.textLabel!.text = user.title
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userLocations.count
  }
  
  //MARK: - UITableView delegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let user = userLocations[indexPath.row]
    
    if let url = NSURL(string: user.link) {
      if UIApplication.sharedApplication().canOpenURL(url) {
        UIApplication.sharedApplication().openURL(url)
      }
    }
  }
  
  //MARK: - Helper methods
  
  func getUserLocations() {
    ParseHelper.sharedInstance.getStudentLocations(100, completion: {
      (users, error) in
      if error != nil {
        print("call back error " + error!)
        return
      }
      
      guard let users = users else {
        print("Couldn't get users. Was probably nil.")
        return
      }
      
      for user in users {
        if let userLocation = UserLocation.fromJSON(user as! NSDictionary) {
          self.userLocations.append(userLocation)
        }
      }
      
      self.tableView.reloadData()
    })
  }

}

