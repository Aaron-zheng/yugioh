//
//  DeckViewEntityConstant.swift
//  yugioh
//
//  Created by Aaron on 9/8/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation

var yearAndMonthLimitConstant = "2018年10月OCG"


var deckViewEntitysConstant: [DeckViewEntity] = [
    DeckViewEntity(id: "0", title: "我的卡组", introduction: "我的卡组", deckEntitys: [String: [DeckEntity]](), type: ""),
    getBanDeckViewEntity(deckName: "ocg"),
    getBanDeckViewEntity(deckName: "tcg"),
    getChampionDeckViewEntity(deckName: "2017"),
    getChampionDeckViewEntity(deckName: "2016"),
    getChampionDeckViewEntity(deckName: "2015"),
    getChampionDeckViewEntity(deckName: "2014"),
    getChampionDeckViewEntity(deckName: "2013"),
    getChampionDeckViewEntity(deckName: "2012"),
    getChampionDeckViewEntity(deckName: "2011"),
    getChampionDeckViewEntity(deckName: "2010"),
    getChampionDeckViewEntity(deckName: "2009"),
    getChampionDeckViewEntity(deckName: "2008"),
    getChampionDeckViewEntity(deckName: "2007"),
    getChampionDeckViewEntity(deckName: "2006"),
    getChampionDeckViewEntity(deckName: "2005"),
    getChampionDeckViewEntity(deckName: "2004"),
    getChampionDeckViewEntity(deckName: "2003")
]
