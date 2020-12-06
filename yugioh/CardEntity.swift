//
//  CardEntity.swift
//  yugioh
//
//  Created by Aaron on 21/10/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation

class CardEntity {
    
    // 唯一标识
    var id: String! = ""
    
    // 名称
    var titleName: String! = ""
    
    // 类型，空格隔离
    var type: String! = ""
    
    // 密码，唯一标识
    var password: String! = ""
    
    // 用处，禁止，限制，准限制，无限制（目前已经弃用）
    var usage: String! = ""
    
    // 种族，鸟兽，念动力，等等
    var race: String! = ""
    
    // 属性，光，暗，风，等灯
    var property: String! = ""
    
    // 星级
    var star: String! = ""
    
    // 攻击力
    var attack: String! = ""
    
    // 防御力
    var defense: String! = ""
    
    // 珍稀程度
    var rare: String! = ""
    
    // 效果
    var effect: String! = ""
    
    // 所属卡包
    var pack: String! = ""
    
    // 灵摆，数字表示
    var scale: String! = ""
    
    // 调整
    var adjust: String! = ""
    
    // 连接，数字表示
    var link: String! = ""
    
    // 连接标记，大概为 左上，左下
    var linkMarker: String! = ""
    
    // 额外添加属性
    // var url: String! = ""
    var isSelected: Bool = false
}
