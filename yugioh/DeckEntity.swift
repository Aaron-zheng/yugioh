//
//  DeckEntity.swift
//  yugioh
//
//  Created by Aaron on 15/7/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation

class DeckEntity {
 
    public var id: String = ""
    public var number: Int = 0
    public var type: String = ""
    
    
    init() {
        
    }
    
    
    init(id: String, number: Int) {
        self.id = id
        self.number = number
        self.type = ""
    }
    
    init(id: String, number: Int, type: String) {
        self.id = id
        self.number = number
        self.type = type
    }
    
}
