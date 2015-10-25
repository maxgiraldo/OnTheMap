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
    if let annotation = annotation as? UserLocation {
      let identifier = "pin"
      var view: MKPinAnnotationView
      if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        as? MKPinAnnotationView { // 2
          dequeuedView.annotation = annotation
          dequeuedView.animatesDrop = true
          view = dequeuedView
      } else {
        // 3
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.animatesDrop = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
      }
      return view
    }
    return nil
  }
  
  func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    print("calloutAccessoryControlTapped")
    let userLocation = view.annotation as! UserLocation
    let urlString = userLocation.link
    let url = NSURL(fileURLWithPath: urlString)
    UIApplication.sharedApplication().openURL(url)
  }
  
  //MARK: - Map data population
  
  func displayUserLocations() {
    if let users = self.users {
      for user in users {
        dropPin(user as! NSDictionary)
      }
    }
  }
  
  func dropPin(user: NSDictionary) {
    guard let lat = user.valueForKey("latitude") as? CLLocationDegrees else {return}
    guard let long = user.valueForKey("longitude") as? CLLocationDegrees else {return}
    guard let locationName = user.valueForKey("mapString") as? String else {return}
    guard let firstName = user.valueForKey("firstName") as? String else {return}
    guard let lastName = user.valueForKey("lastName") as? String else {return}
    guard let link = user.valueForKey("mediaURL") as? String else {return}
    
    let fullName = "\(firstName) \(lastName)"
    let coordinate = CLLocationCoordinate2DMake(lat, long)
    
    let userLocation = UserLocation(title: fullName, locationName: locationName, link: link, coordinate: coordinate)
    
    mapView.addAnnotation(userLocation)
  }
  
}

