//
//  QuestionManagerProtocol.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import Foundation

protocol QuestionManagerProtocol {
    
    func getQuestionList(limit: Int, offset: Int, filter: String?, result: @escaping([Question]?, Error?) -> Void)
}
