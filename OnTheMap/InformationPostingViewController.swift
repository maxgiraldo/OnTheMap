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
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var enterLink: UITextField!
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var blueView: UIView!
  @IBOutlet weak var mainLabel: UILabel!
  
  var coordinates: CLLocationCoordinate2D?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    findOnMapButton.layer.cornerRadius = 4
    submitButton.layer.cornerRadius = 4
    submitButton.clipsToBounds = true
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
      self.coordinates = region.center
      
      self.transitionToMap()
    })
  }
  
  @IBAction func cancelButtonTapped(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  //MARK: - UI
  
  func hideSearchView() {
    findOnMapButton.hidden = true
    blueView.hidden = true
    mainLabel.hidden = true
  }
  
  func unhideMapView() {
    bottomView.alpha = 0.5
    mapView.hidden = false
    submitButton.hidden = false
    enterLink.hidden = false
  }
  
  func transitionToMap() {
    hideSearchView()
    unhideMapView()
    
    let annotation = MKPointAnnotation()
    guard let coords = coordinates else {
      errorAlert("Place Not Found")
      return
    }
    annotation.coordinate = coords
    annotation.title = textField.text!

    let span = MKCoordinateSpanMake(0.1, 0.1)
    let region = MKCoordinateRegionMake(coords, span)
    mapView.addAnnotation(annotation)
    mapView.region = region
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
