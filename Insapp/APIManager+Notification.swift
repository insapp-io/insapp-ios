//
//  APIManager+Notification.swift
//  Insapp
//
//  Created by Florent THOMAS-MOREL on 9/19/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit


let kNotificationUserId = "userid"
let kNotificationToken = "token"
let kNotificationOs = "os"

extension APIManager {
    
    static func updateNotification(token: String, user: User){
        let params = [
            kNotificationUserId: user.id,
            kNotificationToken: token,
            kNotificationOs: "iOS",
            ]
        request(url: "/notifications", method: .post, parameters: params as [String : AnyObject], completion: { result in
            
        }) { (errorMessage, statusCode) in
            
            return false }
    }
    
    static func fetchNotifications(controller: UIViewController, completion:@escaping (_ notifications:[Notification]) -> ()){
        let user_id = User.fetch()!.id
        request(url: "/notifications/\(user_id)", method: .get, completion: { result in
            guard let resultJson = result as? Dictionary<String, AnyObject> else { completion([]) ; return }
            guard let notifJsonArray = resultJson["notifications"] as? [Dictionary<String, AnyObject>] else { completion([]) ; return }
            completion(Notification.parseArray(notifJsonArray))
        }) { (errorMessage, statusCode) in return controller.triggerError(errorMessage, statusCode) }
    }
    
    static func readNotification(notification: Notification, controller: UIViewController, completion:@escaping (_ notification:Optional<Notification>) -> ()){
        let user_id = User.fetch()!.id
        let notif_id = notification.id!
        request(url: "/notifications/\(user_id)/\(notif_id)", method: .delete, completion: { result in
            guard let notifJson = result as? Dictionary<String, AnyObject> else { completion(.none) ; return }
            completion(Notification.parseJson(notifJson))
        }) { (errorMessage, statusCode) in return controller.triggerError(errorMessage, statusCode) }
    }

    
}

