//
//  ParseHelper.swift
//  OnTheMap
//
//  Created by Maximilian A. Giraldo on 10/24/15.
//  Copyright © 2015 Maximilian A. Giraldo. All rights reserved.
//

import Foundation

class ParseHelper {
  
  static let sharedInstance = ParseHelper()
  let baseUrl = "https://api.parse.com/1/classes"
  
  private init() {}
  
  //MARK: - Methods
  
  func getStudentLocations(limit: Int, completion: (data: NSArray?, error: String?) -> Void) {
    let methodArguments = [
      "limit": limit
    ]
    let urlString = baseUrl + "/StudentLocation" + escapedParameters(methodArguments)
    let url = NSURL(string: urlString)!

    let request = NSMutableURLRequest(URL: url)
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
      if error != nil {
        completion(data: nil, error: error!.localizedDescription)
        return
      }
      
      let parsedResult: AnyObject!
      do {
        parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
        
        guard let users = parsedResult["results"] as? NSArray else {
          if let errorMessage = parsedResult["error"] as? String {
            print("Error: \(errorMessage)")
            dispatch_async(dispatch_get_main_queue(), {
              completion(data: nil, error: errorMessage)
            })
          }
          return
        }
        
        completion(data: users, error: nil)
      } catch {
        parsedResult = nil
        completion(data: nil, error: "Could not parse the data as JSON")
        return
      }
    }
    
    task.resume()
  }
  
  //MARK: - Helpers
  
  func escapedParameters(parameters: [String : AnyObject]) -> String {
    
    var urlVars = [String]()
    
    for (key, value) in parameters {
      
      /* Make sure that it is a string value */
      let stringValue = "\(value)"
      
      /* Escape it */
      let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
      
      /* Append it */
      urlVars += [key + "=" + "\(escapedValue!)"]
      
    }
    
    return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
  }
  
  private func parseJSON() {
    
  }
  
}