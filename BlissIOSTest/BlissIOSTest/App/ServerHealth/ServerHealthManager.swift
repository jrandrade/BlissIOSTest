//
//  ServerHealthManager.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit

class ServerHealthManager: ServerHealthManagerProtocol{
    
    let service = ServerHealthHttpService()
    
    func getServerHealth(result: @escaping (Bool?, Error?) -> Void) {
        service.getServerHealth { (health, error) in
            result(health, error)
        }
    }
}
