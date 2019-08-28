//
//  EditUserViewController.swift
//  Insapp
//
//  Created by Florent THOMAS-MOREL on 9/13/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

class EditUserViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    var settingViewController:EditUserTableViewController?
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingViewController = self.childViewControllers.last as? EditUserTableViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavBar()
        self.notifyGoogleAnalytics()
        self.settingViewController?.avatarImageView.image = user?.avatar()
        self.settingViewController?.usernameTextField.text = "@\(user!.username!)"
        self.settingViewController?.nameTextField.text = user!.name
        self.settingViewController?.emailTextField.text = user!.email
        self.settingViewController?.descriptionTextView.text = user!.desc
        self.settingViewController?.promotionTextField.text = user!.promotion
        self.settingViewController?.genderTextField.text = convertGender[user!.gender!]
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditUserViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditUserViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.lightStatusBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame = (userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue
        self.keyboardHeightConstraint.constant = keyboardFrame.height
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.keyboardHeightConstraint.constant = 0
    }
    
    @IBAction func dismissAction(_ sender: AnyObject) {
        self.settingViewController?.view.resignFirstResponder()
        self.settingViewController?.view.endEditing(true)
        //fabricTopFrame.origin.y -= fabricTopFrame.size.height
        /*UIView.animate(withDuration: 5.0, delay: 5.0, options: .curveLinear, animations: {
            topFrame.origin.y -= topFrame.size.height
            self.view.frame = topFrame
        }, completion: { finished in
            print("Ok!")
        })*/
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        if let field = self.checkForm() {
            field.textColor = UIColor.red
        }else{
            self.subscribeToTopics()
            self.startLoading()
            APIManager.update(user: self.user!, controller: self, completion: { (opt_user) in
                guard let _ = opt_user else { return }
                self.stopLoading()
                self.dismissAction(self)
            })
        }
    }
    
    func subscribeToTopics(){
        let promoNotif:String = user!.promotion!
        if let postNotification = UserDefaults.standard.object(forKey: kPushPostNotifications) as?    Bool {
            if promoNotif != ""{
                let topicPost : String = "posts-"+promoNotif
                if postNotification {
                    appDelegate.subscribeToTopicNotification(topic: topicPost)
                }
                else{
                    appDelegate.unsubscribeToTopicNotification(topic: topicPost)
                }
            }
            if postNotification {
                appDelegate.subscribeToTopicNotification(topic: "posts-ios")
                appDelegate.subscribeToTopicNotification(topic: "posts-noclass")
            }
            else{
                appDelegate.unsubscribeToTopicNotification(topic: "posts-ios")
                appDelegate.unsubscribeToTopicNotification(topic: "posts-noclass")
            }
                
        }
            
        if let eventNotification = UserDefaults.standard.object(forKey: kPushEventNotifications) as? Bool    {
            if promoNotif != ""{
                let topicEvent : String = "events-"+promoNotif
                if eventNotification {
                    appDelegate.subscribeToTopicNotification(topic: topicEvent)
                }
                else{
                    appDelegate.unsubscribeToTopicNotification(topic: topicEvent)
                }
            }
            if eventNotification {
                appDelegate.subscribeToTopicNotification(topic: "events-ios")
                appDelegate.subscribeToTopicNotification(topic: "events-noclass")
            }
            else{
                appDelegate.unsubscribeToTopicNotification(topic: "events-ios")
                appDelegate.unsubscribeToTopicNotification(topic: "events-noclass")
            }
        }
    }
    
    func checkForm() -> Optional<UITextField> {
        guard let name = self.settingViewController!.nameTextField.text else { return self.settingViewController!.nameTextField }
        
        let promotion = self.settingViewController!.promotionTextField.text
        let gender = self.settingViewController!.genderTextField.text
        let email = self.settingViewController!.emailTextField.text
        
        user?.name = name.replacingOccurrences(of: "\u{00a0}", with: " ")
        user?.email = email
        user?.promotion = promotion
        user?.gender = convertGender[gender!]
        user?.desc = ""
        
        let characters = NSMutableCharacterSet.alphanumeric()
        characters.addCharacters(in: NSRange(location: 0x1F300, length: 0x1F700 - 0x1F300))
        if var description = self.settingViewController?.descriptionTextView.text, let _ = description.rangeOfCharacter(from: characters as CharacterSet) {
            description.condenseNewLine()
            user?.desc = description
        }
        
        return nil
    }
}

