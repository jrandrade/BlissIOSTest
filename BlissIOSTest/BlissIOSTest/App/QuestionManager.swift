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
    
    func share(isDetail: Bool, id: Int?, filter: String?, destinationEmail: String, result: @escaping (Bool?, Error?) -> Void) {
        service.share(isDetail: isDetail, id: id, filter: filter, destinationEmail: destinationEmail) { (success, error) in
            result(success, error)
        }
    }
}
