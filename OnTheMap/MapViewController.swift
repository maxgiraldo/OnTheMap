//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Maximilian A. Giraldo on 10/23/15.
//  Copyright © 2015 Maximilian A. Giraldo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

  @IBOutlet weak var mapView: MKMapView!
  var users: NSArray?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    mapView.delegate = self
    
    ParseHelper.sharedInstance.getStudentLocations(100, completion: {
      (users, error) in
      if error != nil {
        print("call back error " + error!)
        return
      }
      
      self.users = users
      self.displayUserLocations()
    })
  }
  
  //MARK: - MapView delegate
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseId = "UserLocations"
    let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
    annotationView.animatesDrop = true
    
    return annotationView
  }
  
//  func mapView(mapView: MKMapView, viewForOverlay overlay: MKOverlay) -> MKOverlayView {
//    //TODO: click to show banner?
//  }
  
  //MARK: - Map data population
  
  func displayUserLocations() {
    if let users = self.users {
      for user in users {
        dropPin(user as! NSDictionary)
      }
    }
  }
  
  func dropPin(user: NSDictionary) {
    let lat = user.valueForKey("latitude") as! CLLocationDegrees
    let long = user.valueForKey("longitude") as! CLLocationDegrees
    let title = user.valueForKey("mapString") as! String
    
    //let firstName = user.valueForKey("firstName") as? String
    //let lastName = user.valueForKey("lastName") as? String
    //let fullName = "\(firstName) \(lastName)"
    
    let location = CLLocationCoordinate2DMake(lat, long)
    let dropPin = MKPointAnnotation()
    dropPin.coordinate = location
    dropPin.title = title
    mapView.addAnnotation(dropPin)
  }
  
}

