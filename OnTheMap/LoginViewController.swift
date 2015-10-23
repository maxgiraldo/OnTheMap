//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Maximilian A. Giraldo on 10/23/15.
//  Copyright © 2015 Maximilian A. Giraldo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  @IBOutlet weak var emailTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpUI()
  }

  func setUpUI() {
    emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.50)
    emailTextField.textColor = UIColor.whiteColor()
    emailTextField.attributedPlaceholder =
      NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
  }

}
