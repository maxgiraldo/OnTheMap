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
  
  //MARK: - Methods
  
  func login(email: String, password: String, completion: (user: Dictionary<String, AnyObject>?, errorMessage: String?) -> Void) {
    let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
    request.HTTPMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
      if error != nil {
        dispatch_async(dispatch_get_main_queue(), {
          completion(user: nil, errorMessage: error!.localizedDescription)
        })
        return
      }
      
      if let httpResponse = response as? NSHTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: response!.URL!)
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response!.URL!, mainDocumentURL: nil)
        for cookie in cookies {
          var cookieProperties = [String: AnyObject]()
          cookieProperties[NSHTTPCookieName] = cookie.name
          cookieProperties[NSHTTPCookieValue] = cookie.value
          cookieProperties[NSHTTPCookieDomain] = cookie.domain
          cookieProperties[NSHTTPCookiePath] = cookie.path
          cookieProperties[NSHTTPCookieVersion] = NSNumber(integer: cookie.version)
          cookieProperties[NSHTTPCookieExpires] = NSDate().dateByAddingTimeInterval(31536000)
          
          let newCookie = NSHTTPCookie(properties: cookieProperties)
          NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(newCookie!)
          
          print("name: \(cookie.name) value: \(cookie.value)")
        }
      }
      
      // Ignore 5 characters at beginning used for security purposes
      let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
      let parsedResult: AnyObject!
      
      do {
        parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        guard let session = parsedResult["session"] as? [String: String] else {
          print("Failed to get session from Udacity's servers")
          
          if let errorMessage = parsedResult["error"] as? String {
            dispatch_async(dispatch_get_main_queue(), {
              completion(user: nil, errorMessage: errorMessage)
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
          guard let jsonResult = parsedResult as? Dictionary<String, AnyObject> else {
            completion(user: nil, errorMessage: "Could not find user")
            return
          }
          completion(user: jsonResult, errorMessage: nil)
        })
      } catch {
        parsedResult = nil
        print("Could not parse the data as JSON: '\(data)'")
        return
      }
    }
    task.resume()

  }
  
  func getAuthenticatedUser(completion: (user: [String: AnyObject]?, error: String?) -> Void) {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    guard let userId = appDelegate.userKey else {return}
    let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(userId)")!)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
      if error != nil {
        completion(user: nil, error: error!.localizedDescription)
        return
      }
      let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
      let parsedResult: AnyObject!
      
      do {
        parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        if let responseCode = parsedResult["status"] as? Int {
          print("Response code: \(responseCode)")
          if responseCode == 404 {
            completion(user: nil, error: "User not found")
          }
          return
        }
        
        guard let user = parsedResult["user"] as? [String: AnyObject] else {
          print("Failed to cast user as Dictionary<String, AnyObject>")
          return
        }
        completion(user: user, error: nil)
      } catch {
        completion(user: nil, error: "Error obtaining data")
      }
      
    }
    
    task.resume()
  }
  
  func logout() {
    let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
    request.HTTPMethod = "DELETE"
    var xsrfCookie: NSHTTPCookie? = nil
    let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    for cookie in sharedCookieStorage.cookies! as [NSHTTPCookie] {
      if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
      request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
      if error != nil {
        print("Failed to delete session: \(error!.localizedDescription)")
        return
      }
      let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
      print(NSString(data: newData, encoding: NSUTF8StringEncoding))
    }
    task.resume()
  }
  
}