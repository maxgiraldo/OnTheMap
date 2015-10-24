//
//  Udacity.swift
//  OnTheMap
//
//  Created by Maximilian A. Giraldo on 10/24/15.
//  Copyright © 2015 Maximilian A. Giraldo. All rights reserved.
//

import Foundation

class Udacity {
  
  static let sharedInstance = Udacity()
  
  private init() {}
  
  //MARK: - Properties
  
  var authenticatedUser = {
    return [
      "id": "3384928838",
      "registered": true
    ]
  }
  
  //MARK: - Methods
  
  func login(email: String, password: String, completion: (success: Bool, errorMessage: String?) -> Void) {
    let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
    request.HTTPMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
      if error != nil {
        dispatch_async(dispatch_get_main_queue(), {
          completion(success: false, errorMessage: error!.localizedDescription)
        })
        return
      }
      // Ignore 5 characters at beginning used for security purposes
      let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
      let parsedResult: AnyObject!
      
      do {
        parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        print(parsedResult)
        guard let session = parsedResult["session"] as? [String: String] else {
          print("Failed to get session from Udacity's servers")
          
          if let errorMessage = parsedResult["error"] as? String {
            dispatch_async(dispatch_get_main_queue(), {
              completion(success: false, errorMessage: errorMessage)
            })
          }
          
          return
        }
        
        guard let sessionId = session["id"] else {
          print("Failed to get session ID")
          return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
          let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
          appDelegate.sessionId = sessionId
          completion(success: true, errorMessage: nil)
        })
      } catch {
        parsedResult = nil
        print("Could not parse the data as JSON: '\(data)'")
        return
      }
    }
    task.resume()

  }
  
}