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
    func share(isDetail:Bool, id: Int?, filter: String?, destinationEmail: String, result: @escaping(Bool?, Error?) -> Void)
    func updateQuestion(_ question: Question, result: @escaping(Question?, Error?) -> Void)
    func getQuestion(id: Int, result: @escaping(Question?, Error?) -> Void)
}
