//
//  HelperManage.swift
//  On The Map
//
//  Created by Mouhamed  on 8/2/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation
import UIKit


// encapsulate several functionalities for cleaner code

struct HelperManager {
    
    static let  defaults = UserDefaults.standard
    
    static func parseData(data: Data) -> Data {
           let range = 5..<data.count
           let newData = data.subdata(in: range)
          return newData
     }
    
    
    static func openURL(urlString: String?) -> Bool {
        guard let urlString = urlString else {return false}
        if let url = URL(string: urlString){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return true
        } else {
            return false
        }
    }
    
    static func fetchCookie() -> [String: String]?  {
        
        var cookie: [String: String]?
        var xsrfCookie: HTTPCookie? = nil
        
              let sharedCookieStorage = HTTPCookieStorage.shared
              for cookie in sharedCookieStorage.cookies! {
                  if cookie.name == "XSRF-TOKEN" {xsrfCookie = cookie}
              }
          
              if let xsrfCookie = xsrfCookie {
                   cookie = [xsrfCookie.value: "X-XSRF-TOKEN"]
              }
              return cookie
       }
    
    static func setLoginState(to logingState: Bool) {
        
        AppState.islogedIn = logingState
        defaults.set(AppState.islogedIn, forKey: "loggedIn")

    }
}
