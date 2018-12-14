//
//  ServerHealthHttpServiceProtocol.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import Foundation
protocol ServerHealthHttpServiceProtocol {
    func getServerHealth(result: @escaping(Bool?, Error?) -> Void)
}
