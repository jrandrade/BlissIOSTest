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
    struct notifications {
        static let network = Notification.Name(rawValue: "blissiostest.notification.network")
    }
    struct endpoint {
        static let serverHealth = "/health"
        static let questionList = "/questions"
        static let share = "/share"
        static let update = "/questions/%d"
    }
    
    struct storyboard {
        static let main = "Main"
        static let question = "Question"
    }
    
    struct request {
        static let limit = 10
    }
    
    struct share {
        static let url = "blissrecruitment://questions"
        static let list = "?question_filter=%@"
        static let detail = "?question_id=%d"
    }
}
