//
//  CardEntity.swift
//  yugioh
//
//  Created by Aaron on 21/10/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation

class CardEntity {
    
    //和xml数据库对应的属性
    var id: String! = ""
    var titleChinese: String! = ""
    var titleJapanese: String! = ""
    var titleEnglish: String! = ""
    var type: String! = ""
    var password: String! = ""
    var usage: String! = ""
    var race: String! = ""
    var property: String! = ""
    var star: String! = ""
    var attack: String! = ""
    var defense: String! = ""
    var rare: String! = ""
    var effect: String! = ""
    var pack: String! = ""
    var scale: String! = ""
    var adjust: String! = ""
    
    
    //额外添加属性
    //var url: String! = ""
    var isSelected: Bool = false
}
