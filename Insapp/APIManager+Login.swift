//
//  APIManager+Login.swift
//  Insapp
//
//  Created by Florent THOMAS-MOREL on 9/13/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

extension APIManager{
    
    static func verifyUser(username: String, password: String, controller: UIViewController, completion:@escaping (Bool) -> ()){
        let params = [
            kLoginUsername: username,
            kLoginPassword: password
        ]
        requestCas(url: "/cas/v1/tickets", method: .post, parameters: params as [String : AnyObject], completion: { result in
            completion(result)
        }) { (errorMessage, statusCode) in completion(false) ; return false }
    }
    
    static func signin(ticket: String, controller: UIViewController, completion:@escaping (Optional<User>) -> ()){
        request(url: "/login/user/" + ticket, method: .post,completion: { result in
            
            if let authToken = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == kCredentialsAuthToken }) {
                //print("AuthToken: \(authToken.value)")
            }
            if let refreshToken = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == kCredentialsRefreshToken }) {
                //print("RefreshToken: \(authToken.value)")
            }
            
            guard let json = result as? Dictionary<String, AnyObject>
                else { completion(.none) ; return }
                completion(User.parseJson(json))
        }) { (errorMessage, statusCode) in return controller.triggerError(errorMessage, statusCode) }
        
        }
    
}
