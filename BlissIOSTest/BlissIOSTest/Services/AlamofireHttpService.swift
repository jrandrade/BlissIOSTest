//
//  AlamofireHttpService.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON


class AlamofireHttpService : HttpServiceProtocol {
    
    
    static  let sharedInstance = AlamofireHttpService()
    private let manager: Alamofire.SessionManager
    private let configuration = URLSessionConfiguration.default
    private var lastRequest:DataRequest!
    
    private init() {
        configuration.timeoutIntervalForRequest = 8
        configuration.timeoutIntervalForResource = 8
        manager = Alamofire.SessionManager(configuration: configuration)
        manager.adapter = HeadersAdapter()
    }
    
    
    
    func request(url: String, method: HttpMethods, params: [String : AnyObject?]?, headers: [String : AnyObject]?,  callback : @escaping (HttpResponse) -> Void) {
        
        var requestHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        if (headers != nil) {
            requestHeaders = headers! as! HTTPHeaders
        }
        
        
        var alamofireMethod: HTTPMethod = .get
        
        if method == .POST {
            alamofireMethod = HTTPMethod.post
        } else if method == .PUT {
            alamofireMethod = HTTPMethod.put
        } else if method == .DELETE {
            alamofireMethod = HTTPMethod.delete
        }
        //print(url)
        lastRequest = manager.request(url,
                                      method: alamofireMethod,
                                      parameters: params,
                                      encoding: JSONEncoding.default,
                                      headers: requestHeaders).validate().responseJSON {
                                       response in
                                        
                                        switch (response.result) {
                                        case .success(let value):
                                            
                                            var resp = HttpResponse()
                                            if let unwrappedResponse = response.response {
                                                resp.statusCode = unwrappedResponse.statusCode
                                            }
                                            resp.error = nil
                                            //resp.value = JSON(value).dictionaryObject?["data"]
                                            resp.value = JSON(value)
                                            callback(resp)
                                            
                                            break
                                        case .failure(let error):
                                            
                                            
                                            if NetworkReachabilityManager()!.isReachable {
                                                
                                                guard response.data != nil else {
                                                    
                                                    let error = NSError(
                                                        domain: Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String,
                                                        code: (response.response?.statusCode)!,
                                                        userInfo: [
                                                            NSLocalizedDescriptionKey: error.localizedDescription
                                                        ])
                                                    var resp = HttpResponse()
                                                    resp.error = error
                                                    resp.value = nil
                                                    callback(resp)
                                                    return
                                                }
                                                
                                                let error = NSError(
                                                    domain: Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String,
                                                    code: response.response?.statusCode ?? 404,
                                                    userInfo: [
                                                        NSLocalizedDescriptionKey: JSON(response.data!).dictionaryObject?["error"] ?? ""
                                                    ])
                                                                                                
                                                var resp = HttpResponse()
                                                resp.error = error
                                                resp.value = nil
                                                callback(resp)
                                                
                                            } else {

                                                let error = NSError(
                                                    domain: Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String,
                                                    code: response.response?.statusCode ?? 404,
                                                    userInfo: [
                                                        NSLocalizedDescriptionKey: "ERROR_NO_INTERNET"
                                                    ])
                                                
                                                var resp = HttpResponse()
                                                resp.error = error
                                                resp.value = nil
                                                callback(resp)
                                                
                                            }
                                            break
                                        }
        }
        
    }
}

class HeadersAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
}

