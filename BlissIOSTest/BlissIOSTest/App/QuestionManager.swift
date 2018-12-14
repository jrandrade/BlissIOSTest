//
//  QuestionManager.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit

class QuestionManager: NSObject, QuestionManagerProtocol {
    let service = QuestionHttpService()
    
    func getQuestionList(limit: Int, offset: Int, filter: String?, result: @escaping ([Question]?, Error?) -> Void) {
        service.getQuestionList(limit: limit, offset: offset, filter: filter) { (list, error) in
            result(list, error)
        }
    }
}
