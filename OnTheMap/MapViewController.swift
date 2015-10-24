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

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  //MARK: - MapView delegate
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseId = ""
    let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
    
    return annotationView
  }
  
  //MARK: - Map data population
  
  func displayLast100Users() {
    //TODO: pins specifying the last 100 locations posted by students.
    
  }
  
  func dropPin() {
    let point = CLLocationCoordinate2D(latitude: 53.58448, longitude: -8.93772)
//    AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:ctrpoint];
//    [mapview addAnnotation:addAnnotation];
//    [addAnnotation release];
  }
  
}

