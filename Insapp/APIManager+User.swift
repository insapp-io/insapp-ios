//
//  APIManager+User.swift
//  Insapp
//
//  Created by Florent THOMAS-MOREL on 9/13/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

enum Result {
    case success
    case failure
}

extension APIManager{
    
    static func fetch(user_id: String, controller: UIViewController, completion:@escaping (_ user:Optional<User>) -> ()){
        request(url: "/users/\(user_id)", method: .get, completion: { (result) in
            guard let json = result as? Dictionary<String, AnyObject> else { completion(.none) ; return }
            completion(User.parseJson(json))
        }) { (errorMessage, statusCode) in return controller.triggerError(errorMessage, statusCode) }
    }
    
    static func update(user: User, controller: UIViewController, completion:@escaping (_ user:Optional<User>) -> ()){
        let params = User.toJson(user)
        request(url: "/users/\(user.id!)", method: .put, parameters: params, completion: { (result) in
            guard let json = result as? Dictionary<String, AnyObject> else { completion(.none) ; return }
            completion(User.parseJson(json))
        }) { (errorMessage, statusCode) in return controller.triggerError(errorMessage, statusCode) }
    }
    
    static func delete(user: User, controller: UIViewController, completion:@escaping (_ user:Result) -> ()){
        request(url: "/users/\(user.id!)", method: .delete, completion: { (result) in
            guard let _ = result as? Dictionary<String, AnyObject> else { completion(.failure)  ; return }
            completion(.success)
        }) { (errorMessage, statusCode) in return controller.triggerError(errorMessage, statusCode) }
    }
    
    
    static func report(user: User, controller: UIViewController){
        request(url: "/report/user/\(user.id!)", method: .put, completion: { (_) in
        }) { (errorMessage, statusCode) in return controller.triggerError(errorMessage, statusCode) }
    }
}
