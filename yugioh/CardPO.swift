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
    @NSManaged public var createAt: Date?

}
