//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Maximilian A. Giraldo on 10/25/15.
//  Copyright © 2015 Maximilian A. Giraldo. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var findOnMapButton: UIButton!
  @IBOutlet weak var bottomView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    findOnMapButton.layer.cornerRadius = 4
    textField.delegate = self
  }
  
  //MARK: - Actions
    
  @IBAction func findOnMapButtonTapped(sender: AnyObject) {
    let location = textField.text!
    print("Searching for " + location)
    let localSearchRequest = MKLocalSearchRequest()
    localSearchRequest.naturalLanguageQuery = location
    let localSearch = MKLocalSearch(request: localSearchRequest)

    localSearch.startWithCompletionHandler({ (localSearchResponse, error) -> Void in
      guard let localSearchResponse = localSearchResponse else {
        self.errorAlert("Place Not Found")
        return
      }
      
      let region = localSearchResponse.boundingRegion
      let coordinates = region.center
      let lat = coordinates.latitude
      let long = coordinates.longitude
      print("Lat: \(lat)")
      print("Long: \(long)")
    })
  }
  
  @IBAction func cancelButtonTapped(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  //MARK: - Helper methods
  
  func errorAlert(message: String) {
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  //MARK: - UITextField delegate methods
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

}
