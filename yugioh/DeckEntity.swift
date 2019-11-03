//
//  DeckEntity.swift
//  yugioh
//
//  Created by Aaron on 15/7/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation

class DeckEntity {
 
    //卡牌id，非password
    public var id: String = ""
    
    //卡牌数量
    public var number: Int = 0
    
    //卡组名称
    public var type: String = ""
   

    //目前这里是 1个卡组，可以含有多个卡牌
    //这里的关系有点奇怪，一个卡组，一个卡牌id，再该卡牌id的数量
    //这里当初应该是写成了VO输出了
    
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
