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
  let storyboardId = "InformationPosting"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    mapView.delegate = self
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    displayUserLocations()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    mapView.removeAnnotations(Pin.sharedInstance.userLocations)
  }
  
  //MARK: - Actions
  
  @IBAction func setLocationBarButtonItemTapped(sender: AnyObject) {
    let informationPostingViewController = self.storyboard!.instantiateViewControllerWithIdentifier(storyboardId) as! InformationPostingViewController
    self.presentViewController(informationPostingViewController, animated: true, completion: nil)
  }
  
  @IBAction func refreshBarButtonItemTapped(sender: AnyObject) {
    displayUserLocations()
  }
  
  @IBAction func logoutButtonTapped(sender: AnyObject) {
    Udacity.sharedInstance.logout()
    self.dismissViewControllerAnimated(true, completion: nil)
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
    let userLocation = view.annotation as! UserLocation
    let urlString = userLocation.link
    if let url = NSURL(string: urlString) {
      if UIApplication.sharedApplication().canOpenURL(url) {
        UIApplication.sharedApplication().openURL(url)
      }
    }
  }
  
  //MARK: - Map data population
  
  func displayUserLocations() {
    if Pin.sharedInstance.userLocations.count > 0 {
      mapView.addAnnotations(Pin.sharedInstance.userLocations)
    } else {
      ParseHelper.sharedInstance.getStudentLocations(100, completion: {
        (users, error) in
        if error != nil {
          print("call back error " + error!)
          return
        }
        
        self.users = users
        dispatch_async(dispatch_get_main_queue(), {
          if let users = self.users {
            for user in users {
              if let userLocation = UserLocation.fromJSON(user as! NSDictionary) {
                Pin.sharedInstance.userLocations.append(userLocation)
              }
            }
            
            self.mapView.addAnnotations(Pin.sharedInstance.userLocations)
          }
        })
      })
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

