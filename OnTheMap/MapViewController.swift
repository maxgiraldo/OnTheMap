//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Maximilian A. Giraldo on 10/23/15.
//  Copyright © 2015 Maximilian A. Giraldo. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    // 1. Login
    login()
  }
  
  func login() {
    let loginController = self.storyboard!.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
    self.presentViewController(loginController, animated: false, completion: nil)
  }
  
  

}

