//
//  ServerHealthHttpService.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit
import SwiftyJSON
class ServerHealthHttpService: ServerHealthHttpServiceProtocol {
    let service = AlamofireHttpService.sharedInstance
    init() { }
    
    func getServerHealth(result: @escaping (Bool?, Error?) -> Void) {
        let url = Config.api.url + Config.endpoint.serverHealth
        
        service.request(url: url, method: .GET, params: nil, headers: nil) { (response) in
            guard response.error == nil else {
                result(nil, response.error as? Error)
                return
            }
            
            guard let resultValue = response.value as? JSON, let health = resultValue["status"].string, health == "OK" else {
                result(false, nil)
                return
            }
            
            result(true, nil)
        }
    }
}
