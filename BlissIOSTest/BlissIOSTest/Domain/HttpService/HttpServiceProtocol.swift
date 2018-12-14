//
//  HttpServiceProtocol.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import Foundation

enum HttpMethods {
    
    case GET
    case POST
    case PUT
    case DELETE
}

protocol HttpServiceProtocol {
    
    /*
     *  Perform a basic network request
     */
    func request(url: String, method: HttpMethods, params: [String : AnyObject?]?, headers: [String : AnyObject]?,  callback : @escaping (HttpResponse) -> Void)


}
