//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Maximilian A. Giraldo on 10/23/15.
//  Copyright © 2015 Maximilian A. Giraldo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  @IBOutlet weak var emailTextField: TextField!
  @IBOutlet weak var passwordTextField: TextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var loginLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpUI()
  }
  
  //MARK: - Actions
  
  @IBAction func loginButtonTapped(sender: AnyObject) {
    let email = emailTextField.text
    let password = passwordTextField.text
    
    guard let e = email where email != "" else {
      shakeView(emailTextField)
      loginError("Email cannot be empty")
      return
    }
  
    guard let p = password where password != "" else {
      shakeView(passwordTextField)
      loginError("Password cannot be empty")
      return
    }
    
    Udacity.sharedInstance.login(e, password: p, completion: {
      (success, error) in
      if error != nil {
        self.loginError(error!)
        return
      }
      
      self.loadMainView()
    })
  }
  
  @IBAction func signUpButtonTapped(sender: AnyObject) {
    print("Sign up tapped")
    let url = NSURL(fileURLWithPath: "https://www.udacity.com/account/auth#!/signup")
    UIApplication.sharedApplication().openURL(url)
  }
    
  //MARK: - Navigation
  
  func loadMainView() {
    let tbc = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
    tbc.selectedIndex = 0
    self.showViewController(tbc, sender: self)
  }
  
  //MARK: - Error handling
  
  func loginError(message: String) {
    loginLabel.hidden = true
    errorLabel.hidden = false
    shakeView(self.view)
    shakeView(errorLabel)
    showAlert(message)
  }
  
  func showAlert(message: String) {
    let alert = UIAlertController(title: "Error logging in", message: message, preferredStyle: .Alert)
    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alert.addAction(defaultAction)
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  //MARK: - Setup

  func setUpUI() {
    emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.50)
    emailTextField.textColor = UIColor.whiteColor()
    emailTextField.attributedPlaceholder =
      NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
    passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.50)
    passwordTextField.textColor = UIColor.whiteColor()
    passwordTextField.attributedPlaceholder =
      NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
    loginButton.layer.cornerRadius = 4
    loginButton.clipsToBounds = true
  }
  
  //MARK: - Animations
  
  func shakeView(view: AnyObject) {
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.07
    animation.repeatCount = 4
    animation.autoreverses = true
    animation.fromValue = NSValue(CGPoint: CGPointMake(view.center.x - 10, view.center.y))
    animation.toValue = NSValue(CGPoint: CGPointMake(view.center.x + 10, view.center.y))
    view.layer.addAnimation(animation, forKey: "position")
  }

}
