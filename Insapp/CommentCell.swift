//
//  CommentCell.swift
//  Insapp
//
//  Created by Florent THOMAS-MOREL on 9/15/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit




protocol CommentCellDelegate {
    func report(comment: Comment)
    func delete(comment: Comment)
    func open(user: User)
    func open(association: Association)
}

class CommentCell: UITableViewCell, UITextViewDelegate {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var delegate: CommentCellDelegate?
    var parent: UIViewController!
    var association: Association?
    var comment: Comment?
    var user: User?
    
    func addGestureRecognizer() {
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(CommentCell.handleSwipeGesture(_:)))
        swipeGestureRight.direction = .right
        self.frontView.addGestureRecognizer(swipeGestureRight)
        
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(CommentCell.handleSwipeGesture(_:)))
        swipeGestureLeft.direction = .left
        self.frontView.addGestureRecognizer(swipeGestureLeft)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CommentCell.handleTapGesture(_:)))
        self.usernameLabel.addGestureRecognizer(tapGesture)
    }
    
    func removeGestureRecognizer() {
        if let gestureRecognizers = self.frontView.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                self.frontView.removeGestureRecognizer(gestureRecognizer)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CommentCell.handleTapGesture(_:)))
        self.usernameLabel.addGestureRecognizer(tapGesture)
        self.contentTextView.delegate = self
    }
    
    func preloadUserComment(_ comment: Comment){
        self.usernameLabel.text = "@\(comment.user_id!.lowercased())"
        self.timestampLabel.text = comment.date!.timestamp()
        
        let string = comment.content!
        let attributedString = NSMutableAttributedString(string: string)
        let paragrapheStyle = NSMutableParagraphStyle()
        paragrapheStyle.lineSpacing = 0
        
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light), range: NSRange(location:0, length:string.characters.count))
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragrapheStyle, range: NSRange(location:0, length:string.characters.count))
        self.contentTextView.attributedText = attributedString
        
        let contentSize = self.contentTextView.sizeThatFits(self.contentTextView.bounds.size)
        var frame = self.contentTextView.frame
        frame.size.height = contentSize.height
        self.contentTextView.frame = frame
    }
    
    func preloadAssociationComment(association: Association, forText text: String, atDate date: NSDate){
        self.usernameLabel.text = "@\(association.name!.lowercased())"
        self.timestampLabel.text = date.timestamp()
        
        let attributedString = NSMutableAttributedString(string: text)
        let paragrapheStyle = NSMutableParagraphStyle()
        paragrapheStyle.lineSpacing = 0
        
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular), range: NSRange(location:0, length: text.characters.count))
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragrapheStyle, range: NSRange(location:0, length: text.characters.count))
        self.contentTextView.attributedText = attributedString
        
        let contentSize = self.contentTextView.sizeThatFits(self.contentTextView.bounds.size)
        var frame = self.contentTextView.frame
        frame.size.height = contentSize.height
        self.contentTextView.frame = frame
    }

    
    func loadUserComment(_ comment: Comment, user: User){
        let string = comment.content!
        let attributedString = NSMutableAttributedString(string: string)
        for tag in comment.tags!{
            let range = (string as NSString).range(of: tag.name!)
            attributedString.addAttribute(NSAttributedStringKey.link, value: NSURL(string: tag.user!)!, range: range)
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: range)
        }
        
        let paragrapheStyle = NSMutableParagraphStyle()
        paragrapheStyle.lineSpacing = 0
        
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light), range: NSRange(location:0, length:string.characters.count))
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragrapheStyle, range: NSRange(location:0, length:string.characters.count))
        self.contentTextView.attributedText = attributedString
        
        let height = self.contentTextView.contentSize.height
        var newFrame = self.contentTextView.frame
        newFrame.size.height = height
        self.contentTextView.frame = newFrame
        self.timestampLabel.text = comment.date!.timestamp()
        self.comment = comment
        
        self.userImageView.image = user.avatar()
        self.usernameLabel.text = "@\(user.username!.lowercased())"
        self.roundUserImage()
        self.user = user
        self.addGestureRecognizer()
        if user.id! == User.fetch()!.id! {
            self.backgroundColor = kRedColor
            self.button.backgroundColor = kRedColor
            self.iconImageView.image = #imageLiteral(resourceName: "garbage")
        }else{
            self.backgroundColor = kDarkGreyColor
            self.button.backgroundColor = kDarkGreyColor
            self.iconImageView.image = #imageLiteral(resourceName: "warning")
        }
        
    }
    
    func loadAssociationComment(association: Association, forText text: String, atDate date: NSDate){
        self.association = association
        let attributedString = NSMutableAttributedString(string: text)
        
        let paragrapheStyle = NSMutableParagraphStyle()
        paragrapheStyle.lineSpacing = 0
        
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular), range: NSRange(location:0, length: text.characters.count))
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragrapheStyle, range: NSRange(location:0, length:text.characters.count))
        self.contentTextView.attributedText = attributedString
        
        let height = self.contentTextView.contentSize.height
        var newFrame = self.contentTextView.frame
        newFrame.size.height = height
        self.contentTextView.frame = newFrame
        self.contentTextView.dataDetectorTypes = .link
        self.contentTextView.delegate = self
        
        self.usernameLabel.text = "@\(association.name!.lowercased())"
        self.contentTextView.sizeToFit()
        self.timestampLabel.text = date.timestamp()
        self.userImageView.downloadedFrom(link: kCDNHostname + association.profilePhotoURL!)
        self.roundUserImage()
        
        self.removeGestureRecognizer()
    }
    
    func roundUserImage(){
        DispatchQueue.main.async {
            self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2
            self.userImageView.layer.masksToBounds = true
            self.userImageView.backgroundColor = kWhiteColor
            self.userImageView.layer.borderColor = kDarkGreyColor.cgColor
            self.userImageView.layer.borderWidth = 1
        }
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            self.closeSubmenu()
            break
        case UISwipeGestureRecognizerDirection.left:
            self.openSubmenu()
            break
        default: break
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if !URL.absoluteString.contains("http") {
            APIManager.fetch(user_id: URL.absoluteString, controller: self.delegate! as! UIViewController) { (user_opt) in
                guard let user = user_opt else { return }
                self.delegate?.open(user: user)
            }
            return false
        }
        return true
    }
 
    func openSubmenu(){
        if self.frontView.frame.origin.x == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.frontView.frame.origin.x-=80
            })
        }
    }
    
    func closeSubmenu(){
        if self.frontView.frame.origin.x != 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.frontView.frame.origin.x = 0
            })
        }
    }
    
    @IBAction func handleTapGesture(_ sender: AnyObject) {
        if let user = self.user {
            self.delegate?.open(user: user)
        }
        if let association = self.association {
            self.delegate?.open(association: association)
        }
    }
    
    @IBAction func buttonAction(_ sender: AnyObject) {
        if self.iconImageView.image == #imageLiteral(resourceName: "warning") {
            self.delegate?.report(comment: self.comment!)
        }else{
            self.delegate?.delete(comment: self.comment!)
        }
    }
    
}
