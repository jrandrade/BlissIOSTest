//
//  Question.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit
import SwiftyJSON

class Question: NSObject, EntityProtocol {
    
    var id: Int? = nil
    var question: String? = nil
    var image_url: String? = nil
    var thumb_url: String? = nil
    var published_at: String? = nil
    var choices: [Choice]? = nil
    
    required init?(json: JSON) {
        if let id = json["id"].int {
            self.id = id
        }
        
        if let question = json["question"].string {
            self.question = question
        }
        
        if let image_url = json["image_url"].string {
            self.image_url = image_url
        }
        
        if let thumb_url = json["thumb_url"].string {
            self.thumb_url = thumb_url
        }
        
        if let published_at = json["published_at"].string {
            self.published_at = published_at
        }
        
        if let choices = json["choices"].array{
            self.choices = []
            for element in choices {
                if let choice = Choice(json: element) {
                    self.choices?.append(choice)
                }
            }
        }
    }
    func toDict() -> [String : AnyObject?] {
        var dict = [String : AnyObject?]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            
            if let array = child.value as? [Choice] {
                var choiceArray = [AnyObject]()
                for item in array {
                    choiceArray.append(item.toDict() as AnyObject)
                }
                
                if let key = child.label {
                    dict[key] = choiceArray as AnyObject
                }
            } else {
                if let key = child.label {
                    dict[key] = child.value as AnyObject
                }
            }
            
        }
        return dict
    }
    
}
