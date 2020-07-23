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
    
    static func signin(ticket: String, controller: UIViewController, completion:@escaping (Optional<User>) -> ()){
        request(url: "/login/user/" + ticket, method: .post, completion: { result in
            guard let json = result as? Dictionary<String, AnyObject>
                else { completion(.none) ; return }
            
            let authToken = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == kCredentialsAuthToken })
            let refreshToken = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == kCredentialsRefreshToken })
            
            completion(User.parseJson(json))
        }) { (errorMessage, statusCode) in return controller.triggerError(errorMessage, statusCode) }
        }
    
    static func login(_ cookies: Cookies, controller:UIViewController, completion:@escaping (Optional<Cookies>, Optional<User>) -> ()){
        let params = [
            kCredentialsAuthToken: cookies.authToken,
            kCredentialsRefreshToken: cookies.refreshToken
        ]
        request(url: "/login/user", method: .post, parameters: params as [String : AnyObject], completion: { result in
            guard let json = result as? Dictionary<String, AnyObject> else { completion(.none, .none) ; return }
            guard let cookiesJson = json["credentials"] as? Dictionary<String, AnyObject> else { completion(.none, .none) ; return }
            guard let cookies = Cookies.parseJson(cookiesJson) else { completion(.none, .none) ; return }
            guard let token = json["sessionToken"] as? Dictionary<String, AnyObject> else { completion(cookies, .none) ; return }
            guard let userJson = json["user"] as? Dictionary<String, AnyObject> else { completion(cookies, .none) ; return }
            guard let user = User.parseJson(userJson) else {
                completion(cookies, .none)
                return
            }
            
            APIManager.token = token["Token"] as! String
            
            completion(cookies, user)
        }) { (errorMessage, statusCode) in return controller.triggerError(errorMessage, statusCode) }
    }
    
}
