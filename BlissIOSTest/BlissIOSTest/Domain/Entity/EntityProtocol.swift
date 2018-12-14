//
//  EntityProtocol.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol EntityProtocol {
    
    /*
     * Init with json
     */
    init?(json: JSON);
    
}
