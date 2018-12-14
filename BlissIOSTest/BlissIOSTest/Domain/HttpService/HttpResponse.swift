//
//  HttpResponse.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import Foundation
import Foundation

struct HttpResponse {
    
    /*
     * Response status code
     */
    var statusCode: Int? = nil
    
    /*
     * Response Object
     */
    var value: Any? = nil
    
    /*
     * Response Error
     */
    var error: Any? = nil
}
