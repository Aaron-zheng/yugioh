//
//  CardPO+CoreDataClass.swift
//  yugioh
//
//  Created by Aaron on 28/10/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import CoreData

@objc(CardPO)
public class CardPO: NSManagedObject {
    
    @NSManaged public var id: String?
    @NSManaged public var url: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var star: String?
    @NSManaged public var attack: String?
    @NSManaged public var defense: String?
    @NSManaged public var effect: String?
    @NSManaged public var createAt: Date?
    @NSManaged public var pack: String?

}
