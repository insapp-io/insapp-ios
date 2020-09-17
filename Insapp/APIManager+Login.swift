//
//  APIManager+Login.swift
//  Insapp
//
//  Created by Florent THOMAS-MOREL on 9/13/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension APIManager{
    
    static func login(ticket: String, controller: UIViewController, completion:@escaping (Optional<User>) -> ()) {
        request(url: "/login/user/" + ticket, method: .post, completion: { result in
            guard let json = result as? Dictionary<String, AnyObject>
                else { completion(.none) ; return }
            
            let cookies =  readCookies(forURL: kInsappURL!)
            storeCookies(cookies, forURL: kInsappURL!)
            
            completion(User.parseJson(json))
        }) { (errorMessage, statusCode) in return controller.triggerError(errorMessage, statusCode) }
        }
    
    static func logout(){
        deleteCookies(forURL: kInsappURL!)
        APIManager.request(url: "logout/user", method: .post, completion:{ result in
        }){ (errorMessage, statusCode) in return false }
        User.delete()
    }
    
    
    static func isLoggedIn(completion: @escaping(Bool) -> Any){
        let url = URL(string: "\(kAPIHostname)/associations")!
        var req = URLRequest(url: url)
        
        let cookies = readCookies(forURL: kInsappURL!)
        print(cookies)
        if(!cookies.isEmpty){
            req.setValue("AuthToken=\(cookies[0].value); Path=/; Domain=insapp.fr; HttpOnly; Secure", forHTTPHeaderField: "Set-Cookie")
            req.addValue("RefreshToken=\(cookies[1].value); Path=/; Domain=insapp.fr; HttpOnly; Secure", forHTTPHeaderField: "Set-Cookie")
        }
        
        
        var loggedIn = false
        Alamofire.request(req).response{ response in
            print(response.response?.statusCode)
            if(response.response?.statusCode == 401){
                loggedIn = false
            } else {
                loggedIn = true
            }
            print("isLoggedIn : \(loggedIn)")
            completion(loggedIn)
        }
    }
    
    
// MARK: Cookie utilities
    
    static func readCookies(forURL url: URL) -> [HTTPCookie] {
        let cookieStorage = HTTPCookieStorage.shared
        let cookies = cookieStorage.cookies(for: url) ?? []
        return cookies
    }

    static func deleteCookies(forURL url: URL) {
        let cookieStorage = HTTPCookieStorage.shared

        for cookie in readCookies(forURL: url) {
            cookieStorage.deleteCookie(cookie)
        }
    }

    static func storeCookies(_ cookies: [HTTPCookie], forURL url: URL) {
        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.setCookies(cookies,
                                 for: url,
                                 mainDocumentURL: nil)
    }
}
