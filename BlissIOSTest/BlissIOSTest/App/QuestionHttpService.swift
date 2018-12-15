//
//  QuestionHttpService.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit
import SwiftyJSON

class QuestionHttpService: NSObject, QuestionHttpServiceProtocol {
    
    let service = AlamofireHttpService.sharedInstance
    
    func getQuestionList(limit: Int, offset: Int, filter: String?, result: @escaping ([Question]?, Error?) -> Void) {
        let url = Config.api.url + Config.endpoint.questionList
        guard let finalUrl = URL.getWithQueryString(baseUrl: url, queryParams:
            ["limit": limit as AnyObject],
                                                    ["offset": offset as AnyObject],
                                                    ["filter": filter as AnyObject]) else {
                                                        
                                                        let error = NSError(
                                                            domain: Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String,
                                                            code: 404,
                                                            userInfo: [
                                                                NSLocalizedDescriptionKey: "ERROR_MISSING_PARAMETERS"
                                                            ])
                                                        
                                                        result(nil, error)
                                                        
                                                        return
        }
        
        service.request(url: finalUrl, method: .GET, params: nil, headers: nil) { (response) in
            guard response.error == nil else {
                result(nil, response.error as? Error)
                return
            }
            
            guard let resultValue = response.value as? JSON else {
                result(nil, nil)
                return
            }
            
            var list = [Question]()
            if let array = resultValue.array {
                for element in array {
                    if let question = Question(json: element) {
                        list.append(question)
                    }
                }
                
            }
            result(list, nil)
        }
        
    }
    
    func share(isDetail: Bool, id: Int?, filter: String?, destinationEmail: String, result: @escaping (Bool?, Error?) -> Void) {
        
        let url = Config.api.url + Config.endpoint.share
        var contentUrl = Config.share.url
        contentUrl += isDetail ? String(format: Config.share.detail, id ?? 0) : String(format: Config.share.list, filter ?? "")
        
        guard var finalUrl = URL.getWithQueryString(baseUrl: url, queryParams:
            ["destination_email": destinationEmail as AnyObject]) else {
                                                        
                                                        let error = NSError(
                                                            domain: Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String,
                                                            code: 404,
                                                            userInfo: [
                                                                NSLocalizedDescriptionKey: "ERROR_MISSING_PARAMETERS"
                                                            ])
                                                        
                                                        result(nil, error)
                                                        
                                                        return
        }
        finalUrl += "content_url=\(contentUrl)"
        service.request(url: finalUrl, method: .POST, params: nil, headers: nil) { (response) in
            guard response.error == nil else {
                result(nil, response.error as? Error)
                return
            }
            
            guard let resultValue = response.value as? JSON, let health = resultValue["status"].string, health == "OK" else {
                result(false, nil)
                return
            }
            
            result(true, nil)
        }
    }
    
    func updateQuestion(_ question: Question, result: @escaping (Question?, Error?) -> Void) {
        let url = Config.api.url + String(format:Config.endpoint.update, question.id ?? 0)
        
        service.request(url: url, method: .PUT, params: question.toDict(), headers: nil) { (response) in
            guard response.error == nil else {
                result(nil, response.error as? Error)
                return
            }
            
            guard let resultValue = response.value as? JSON, let question = Question(json: resultValue) else {
                result(nil, nil)
                return
            }
            
            result(question, nil)
        }

    }
}
