//
//  UserLocation.swift
//  OnTheMap
//
//  Created by Maximilian A. Giraldo on 10/25/15.
//  Copyright © 2015 Maximilian A. Giraldo. All rights reserved.
//

import MapKit

class UserLocation: NSObject, MKAnnotation {
  let title: String?
  let locationName: String
  let link: String
  let coordinate: CLLocationCoordinate2D
  
  init(title: String, locationName: String, link: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.locationName = locationName
    self.link = link
    self.coordinate = coordinate
    
    super.init()
  }
  
  var subtitle: String? {
    return link
  }
}
