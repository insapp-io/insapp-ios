//
//  Constant.swift
//  Insapp
//
//  Created by Florent THOMAS-MOREL on 9/19/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

//ERROR MESSAGE
let kErrorServer = "Impossible de se connecter au serveur. Vérifie ta connexion et réessaye plus tard!"
let kErrorUnkown = "Une erreur est survenue. Merci de réessayer plus tard!"
let kErrorUserExist = "Ce nom d'utilsateur est déjà utilisé!"
let kErrorBadCASId = "Impossible de vérifier tes identifiants!"

//TUTORIAL
let kTutorialPages = ["TutorialAssociationViewController", "TutorialEventViewController", "TutorialNewsViewController", "TutorialNotificationViewController", "TutorialProfilViewController"]

//COLOR
let kLightGreyColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
let kDarkGreyColor = UIColor.init(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
let kRedColor = UIColor.init(red: 236/255, green: 93/255, blue: 87/255, alpha: 1)
//let kRedColor = UIColor.init(red: 91/255, green: 232/255, blue: 95/255, alpha: 1)
let kWhiteColor = UIColor.white
let kClearColor = UIColor.clear


//FONT
let kNormalFont = "System-Regular"
let kBoldFont = "System-Semibold"
let kLightFont = "System-Light"

//CELL
let kAssociationCell = "kAssociationCell"
let kAssociationEventCellView = "kAssociationEventCellView"
let kEventCell = "kEventCell"
let kEventListCell = "kEventListCell"

let kPostCell = "kPostCell"
let kPostCellEmptyHeight = CGFloat(180)

let kCommentCell = "kCommentCell"
let kCommentCellEmptyHeight = 41
let kCommentCellEmptyWidth = 64

let kCommentViewEmptyHeight = CGFloat(16)
let kCommentEmptyTextViewHeight = CGFloat(33)

let kUserCell = "kUserCell"

let kNotificationCell = "kNotificationCell"

let kSearchPostCell = "SearchPostCell"

let kSearchEventCell = "SearchEventCell"

let kSearchUserCell = "SearchUserCell"

let kSearchAssociationCell = "SearchAssociationCell"

let kAssociationSearchCell = "AssociationSearchCell"

let kSeeMoreCell = "SeeMoreCell"

//API

let kAPIHostname = "https://" + (Bundle.main.infoDictionary?["BaseApiUrl"] as! String)
let kCDNHostname = "https://" + (Bundle.main.infoDictionary?["BaseCdnUrl"] as! String)
//let kAPIHostname = "https://insapp.insa-rennes.fr/api/v1"
//let kCDNHostname = "https://insapp.insa-rennes.fr/cdn/"

let kCASHostname = "https://cas.insa-rennes.fr"
let kLoginPassword = "password"
let kLoginUsername = "username"
let kLoginDeviceId = "device"
let kLoginEraseUser = "erase"



//MODEL
let kMaxTimestampForImage = 864000

let kCommentId      = "ID"
let kCommentUserId  = "user"
let kCommentContent = "content"
let kCommentDate    = "date"
let kCommentTags    = "tags"

let kCommentTagId   = "ID"
let kCommentTagUser = "user"
let kCommentTagName = "name"

let kPostId             = "ID"
let kPostTitle          = "title"
let kPostAssociation    = "association"
let kPostDescription    = "description"
let kPostEvent          = "event"
let kPostDate           = "date"
let kPostLikes          = "likes"
let kPostComments       = "comments"
let kPostPhotoURL       = "image"
let kPostStatus         = "status"
let kPostImageSize      = "imageSize"


let kUserId             = "ID"
let kUserName           = "name"
let kUserUsername       = "username"
let kUserDescription    = "description"
let kUserEmail          = "email"
let kUserEmailIsPublic  = "emailpublic"
let kUserPromotion      = "promotion"
let kUserGender         = "gender"
let kUserEvents         = "events"
let kUserPostLiked      = "postsliked"
let kUserPhotoURL       = "photourl"

let kAssociationId             = "ID"
let kAssociationName           = "name"
let kAssociationEmail          = "email"
let kAssociationDescription    = "description"
let kAssociationEvents         = "events"
let kAssociationPosts          = "posts"
let kAssociationProfile        = "profile"
let kAssociationCover          = "cover"
let kAssociationBgColor        = "bgcolor"
let kAssociationFgColor        = "fgcolor"

let kCredentialsAuthToken       = "authtoken"
let kCredentialsRefreshToken    = "refreshtoken"
let kCredentialsUsername        = "username"
let kCredentialsUserId          = "user"


let kEventId             = "ID"
let kEventName           = "name"
let kEventDescription    = "description"
let kEventAssociation    = "association"
let kEventAttendees      = "participants"
let kEventMaybe          = "maybe"
let kEventNotGoing       = "notgoing"
let kEventComments       = "comments"
let kEventDateStart      = "dateStart"
let kEventDateEnd        = "dateEnd"
let kEventBgColor        = "bgColor"
let kEventFgColor        = "fgColor"
let kEventPhotoURL       = "image"
let kEventStatus         = "status"

let kNotificationId         = "ID"
let kNotificationSender     = "sender"
let kNotificationReceiver   = "receiver"
let kNotificationContent    = "content"
let kNotificationType       = "type"
let kNotificationMessage    = "message"
let kNotificationSeen       = "seen"
let kNotificationDate       = "date"
let kNotificationComment    = "comment"

let kNotificationTypeEvent      = "event"
let kNotificationTypePost       = "post"
let kNotificationTypeTag        = "tag"
let kNotificationTypeEventTag   = "eventTag"


//OTHER
let kMaxDescriptionLength = 120
let kSuggestCalendar = "kSuggestCalendar"
let kBarCodeAmicalistCard = "kBarCodeAmicalistCard"
let kPushPostNotifications = "kPushPostNotifications"
let kPushEventNotifications = "kPushEventNotifications"

let promotions = [
    "", "1STPI", "2STPI",
    "3EII", "3GM", "3GCU", "3GMA", "3INFO", "3SGM", "3SRC", "3CDTI",
    "4EII", "4GM", "4GCU", "4GMA", "4INFO", "4SGM", "4SRC", "4CDTI",
    "5EII", "5GM", "5GCU", "5GMA", "5INFO", "5SGM", "5SRC", "5CDTI",
    "STAFF"
]

let genders = [
    "", "Féminin", "Masculin"
]

let convertGender = [
    ""          : "",
    "female"    : "Féminin",
    "male"      : "Masculin",
    "Féminin"   : "female",
    "Masculin"  : "male"
]
