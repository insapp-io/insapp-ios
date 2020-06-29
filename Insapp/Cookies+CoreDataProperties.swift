//
//  Cookies+CoreDataProperties.swift
//  Insapp
//
//  Created by Théo Prigent on 23/06/2020.
//  Copyright © 2020 Théo PRIGENT. All rights reserved.
//

import Foundation
import CoreData


extension Cookies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cookies> {
        return NSFetchRequest<Cookies>(entityName: "Cookies");
    }

    @NSManaged public var authToken: String
    @NSManaged public var refreshToken: String

}
