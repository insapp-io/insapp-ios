//
//  APIManager.swift
//  Insapp
//
//  Created by Florent THOMAS-MOREL on 9/12/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import Alamofire
import Bagel

class APIManager{
    
    var Object:AnyObject?
    static var token:String!
    static let group = DispatchGroup()
    static let serviceName = "InsappService"
    
    static func process(request: URLRequestConvertible, completion: @escaping (Optional<AnyObject>) -> (), errorBlock: @escaping (String, Int) -> (Bool)){
        { () -> Void in
            var retry = false
            
            let cookies = readCookies(forURL: kInsappURL!)
            print(cookies)
        
        
            Alamofire.request(request).responseJSON { response in
                guard let res = response.response else {
                        retry = errorBlock(kErrorServer, -1)
                        return
                    }
                if(res.statusCode == 401){
                    deleteCookies(forURL: kInsappURL!)
                    APIManager.request(url: "logout/user", method: .post, completion:{ result in
                    }){ (errorMessage, statusCode) in return false }
                    User.delete()
                    
                    
                }
                    var error = kErrorUnkown
                    if let dict = response.result.value as? Dictionary<String, AnyObject>{
                        if let err = dict["error"] as? String {
                            error = err
                        }
                    }
                retry = errorBlock(error, res.statusCode)
                    if !retry {
                        completion(response.result.value as AnyObject)   
                    }
            }
        }()
        
    }
    
    static func request(url:String, method: HTTPMethod, parameters: [String:AnyObject], completion: @escaping (Optional<AnyObject>) -> (), errorBlock:@escaping (String, Int) -> (Bool)) {
        
        User.save()
        
        let url = URL(string: "\(kAPIHostname)\(url)")!
        var req = URLRequest(url: url)
        
        req.httpMethod = method.rawValue
        req.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let cookies = readCookies(forURL: kInsappURL!)
        
        if(!cookies.isEmpty){
            req.setValue("AuthToken=\(cookies[0].value); Path=/; Domain=insapp.fr; Expires=Thu, 08 Oct 2020 20:02:55 GMT; HttpOnly; Secure", forHTTPHeaderField: "Set-Cookie")
            req.addValue("RefreshToken=\(cookies[1].value); Path=/; Domain=insapp.fr; Expires=Thu, 08 Oct 2020 20:02:55 GMT; HttpOnly; Secure", forHTTPHeaderField: "Set-Cookie")
        }
        
        APIManager.process(request: req, completion: completion, errorBlock: errorBlock)
    }
    
    
    static func request(url:String, method: HTTPMethod, completion: @escaping (Optional<AnyObject>) -> (), errorBlock:@escaping (String, Int) -> (Bool)){
        
        User.save()
        
        let url = URL(string: "\(kAPIHostname)\(url)")!
        var req = URLRequest(url: url)
        
        req.httpMethod = method.rawValue
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let cookies = readCookies(forURL: kInsappURL!)
        
        if(!cookies.isEmpty){
            req.setValue("AuthToken=\(cookies[0].value); Path=/; Domain=insapp.fr; Expires=Thu, 08 Oct 2020 20:02:55 GMT; HttpOnly; Secure", forHTTPHeaderField: "Set-Cookie")
            req.addValue("RefreshToken=\(cookies[1].value); Path=/; Domain=insapp.fr; Expires=Thu, 08 Oct 2020 20:02:55 GMT; HttpOnly; Secure", forHTTPHeaderField: "Set-Cookie")
        }
        
        APIManager.process(request: req, completion: completion, errorBlock: errorBlock)
        
    }
    
}
