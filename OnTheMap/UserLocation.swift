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
  
  static func fromJSON(user: NSDictionary) -> UserLocation? {
    guard let lat = user.valueForKey("latitude") as? CLLocationDegrees else {return nil}
    guard let long = user.valueForKey("longitude") as? CLLocationDegrees else {return nil}
    guard let locationName = user.valueForKey("mapString") as? String else {return nil}
    guard let firstName = user.valueForKey("firstName") as? String else {return nil}
    guard let lastName = user.valueForKey("lastName") as? String else {return nil}
    guard let link = user.valueForKey("mediaURL") as? String else {return nil}
    
    let fullName = "\(firstName) \(lastName)"
    let coordinate = CLLocationCoordinate2DMake(lat, long)
    
    return UserLocation(title: fullName, locationName: locationName, link: link, coordinate: coordinate)
  }
}
