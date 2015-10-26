//
//  Pin.swift
//  OnTheMap
//
//  Created by Maximilian A. Giraldo on 10/26/15.
//  Copyright © 2015 Maximilian A. Giraldo. All rights reserved.
//

import Foundation

class Pin {
  
  var userLocations: [UserLocation] = []
  
  static let sharedInstance = Pin()
  private init() {}
  
  
}
