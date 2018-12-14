//
//  Config.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import Foundation

struct Config {
    struct api {
        static let url = "https://private-anon-6f1b9681ee-blissrecruitmentapi.apiary-mock.com"
    }
    
    struct endpoint {
        static let serverHealth = "/health"
        static let questionList = "/questions"
    } 
}
