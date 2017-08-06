//
//  DeckView.swift
//  yugioh
//
//  Created by Aaron on 6/8/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation

class DeckViewEntity {
    
    public var id: String = ""
    public var title: String = ""
    public var introduction: String = ""
    public var deckEntitys: [DeckEntity] = []
    
    
    init(id: String, title: String, introduction: String, deckEntitys: [DeckEntity]) {
        self.id = id
        self.title = title
        self.introduction = introduction
        self.deckEntitys = deckEntitys
    }
    
}
