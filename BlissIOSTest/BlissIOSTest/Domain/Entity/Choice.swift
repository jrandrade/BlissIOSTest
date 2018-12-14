//
//  Choice.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit
import SwiftyJSON

class Choice: NSObject, EntityProtocol{
    var choice: String? = nil
    var votes: Int? = nil
    
    required init?(json: JSON) {
        if let choice = json["choice"].string {
            self.choice = choice
        }
        
        if let votes = json["votes"].int {
            self.votes = votes
        }
    }
}
