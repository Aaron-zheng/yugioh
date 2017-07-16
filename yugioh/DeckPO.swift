//
//  DeckPO.swift
//  yugioh
//
//  Created by Aaron on 15/7/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation
import CoreData

@objc(DeckPO)
public class DeckPO: NSManagedObject {
    
    @NSManaged public var id: String!
    @NSManaged public var number: NSNumber!
    
}
