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
        request(url: "/login/user/" + ticket, method: .post,completion: { result in
            guard let json = result as? Dictionary<String, AnyObject>
                else { completion(.none) ; return }
            
            let authToken = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == kCredentialsAuthToken })
            let refreshToken = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == kCredentialsRefreshToken })
            
            Cookies.init(authToken: authToken!.value, refreshToken: refreshToken!.value)
            
            completion(User.parseJson(json))
        }) { (errorMessage, statusCode) in return controller.triggerError(errorMessage, statusCode) }
        }
}
