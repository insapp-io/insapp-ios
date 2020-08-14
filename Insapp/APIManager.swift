//
//  APIManager.swift
//  Insapp
//
//  Created by Florent THOMAS-MOREL on 9/12/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import Alamofire

class APIManager{
    
    var Object:AnyObject?
    static var token:String!
    static let group = DispatchGroup()
    static let serviceName = "InsappService"
    
    static func process(request: URLRequestConvertible, completion: @escaping (Optional<AnyObject>) -> (), errorBlock: @escaping (String, Int) -> (Bool)){
        { () -> Void in
            var retry = false
            Alamofire.request(request).responseJSON { response in
                guard let res = response.response else {
                        retry = errorBlock(kErrorServer, -1)
                        return
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
                 
                
                if(response.response?.statusCode == 401){       //TODO

                }
                
                /*print("====== BEGIN ======")
                print("-> Request")
                print(response.request)
                print("-> Response")
                print(response.response)    // URL response
                print("-> Result")
                print(response.result)      // result of response serialization
                print("-> Content")
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")  // content
                }
                print("===== END =====")*/
            }
        }()
        
    }
    
    static func request(url:String, method: HTTPMethod, parameters: [String:AnyObject], completion: @escaping (Optional<AnyObject>) -> (), errorBlock:@escaping (String, Int) -> (Bool)){
        let url = URL(string: "\(kAPIHostname)\(url)")!
        var req = URLRequest(url: url)
        
        req.httpMethod = method.rawValue
        req.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        
        APIManager.process(request: req, completion: completion, errorBlock: errorBlock)
    }
    
    
    static func request(url:String, method: HTTPMethod, completion: @escaping (Optional<AnyObject>) -> (), errorBlock:@escaping (String, Int) -> (Bool)){
        let url = URL(string: "\(kAPIHostname)\(url)")!
        var req = URLRequest(url: url)
        
        req.httpMethod = method.rawValue
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
        APIManager.process(request: req, completion: completion, errorBlock: errorBlock)
        
    }
    
}
