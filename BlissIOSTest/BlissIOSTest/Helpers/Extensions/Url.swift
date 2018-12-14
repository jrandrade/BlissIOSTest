//
//  URL.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import Foundation

extension URL {
    
    static func getWithQueryString(baseUrl: String, queryParams: [String: AnyObject?]...) -> String? {
        
        var components = URLComponents(url: URL(string: baseUrl)!, resolvingAgainstBaseURL: true)
        var queryItems = [URLQueryItem]()
        
        for p in queryParams {
            
            if !(p.first?.value is NSNull) {
                
                if let _ = p.first?.value as? Int {
                    
                    if (p.first?.value as! Int) < 0 {
                        continue
                    }
                }
                
                if let _ = p.first?.value as? [String] {
                    
                    for v in p.first?.value as! [String] {
                        queryItems.append(URLQueryItem(name: p.first!.key, value: v))
                    }
                }
                else {
                    queryItems.append(URLQueryItem(name: p.first!.key, value: p.first!.value?.description))
                }
            }
        }
        components?.queryItems = queryItems
        
        return components?.string
    }
    
}
