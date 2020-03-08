//
//  UIVerticalAlignLabel.swift
//  swifttips
//
//  Created by Aaron on 25/7/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

import SQLite


public var Timestamp: String {
    return "\(NSDate().timeIntervalSince1970 * 1000)"
}

public class UIVerticalAlignLabel: UILabel {
    
    enum VerticalAligment: Int {
        case VerticalAligmentTop = 0
        case VerticalAligmentMiddle = 1
        case VerticalAligmentBottom = 2
    }
    
    
    var verticalAligment: VerticalAligment = .VerticalAligmentTop {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /**
     顶部和左对齐的标签
     
     - parameter bounds:
     - parameter numberOfLines:
     
     - returns:
     */
    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        switch verticalAligment {
        case .VerticalAligmentTop:
            return CGRect.init(x: bounds.origin.x, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
        case .VerticalAligmentMiddle:
            return CGRect.init(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
        case .VerticalAligmentBottom:
            return CGRect.init(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
        }
    }
    
    public override func drawText(in rect: CGRect) {
        let r = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: r)
    }
}

//预计算文字高度
func preCalculateTextHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
    let label:UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
}

//获取图片链接
func getCardUrl(id: String) -> String {
    return qiniuUrlPrefix + id + qiniuUrlSuffix
}

//获取所有卡牌列表
func getCardEntity() -> Array<CardEntity> {
    var cardEntitys: Array<CardEntity> = []
    do {
        for each in try getDB().prepare("select a.id, a.titleChinese, a.titleJapanese, a.titleEnglish, a.type, a.password, a.usage, a.race, a.property, a.star, a.attack, a.defense, a.rare, a.effect, a.pack, a.scale, a.adjust, b.id, b.name, b.type, b.desc, b.atk, b.def, b.level, b.race, b.attribute, b.archetype, b.scale, b.linkval, b.linkmarkers, b.card_sets, b.card_images, b.card_prices, b.banlist_info from info a left outer join pro b on a.password = b.id order by (a.id+0) desc") {
            cardEntitys.append(buildCardEntity(element: each))
        }
        
        
    } catch {
        print(error.localizedDescription)
    }
    
    return cardEntitys
}


//获取卡牌详情
func getCardEntity(id: String) -> CardEntity {
    do {
        for each in try getDB().prepare("select a.id, a.titleChinese, a.titleJapanese, a.titleEnglish, a.type, a.password, a.usage, a.race, a.property, a.star, a.attack, a.defense, a.rare, a.effect, a.pack, a.scale, a.adjust, b.id, b.name, b.type, b.desc, b.atk, b.def, b.level, b.race, b.attribute, b.archetype, b.scale, b.linkval, b.linkmarkers, b.card_sets, b.card_images, b.card_prices, b.banlist_info from info a left outer join pro b on a.password = b.id where a.id = \"\(id)\"") {
            return buildCardEntity(element: each)
        }
    } catch {
        print(error.localizedDescription)
    }
    return CardEntity()
}

//获取冠军卡组
func getChampionDeckViewEntity(deckName: String) -> DeckViewEntity {
    return getDeckViewEntity(deckName: deckName, titleName: deckName + "游戏王世界锦标赛冠军卡组")
}
//获取禁卡组
func getBanDeckViewEntity(deckName: String) -> DeckViewEntity {
    return getDeckViewEntity(deckName: deckName, titleName: "2020年1月 " + deckName + " 禁止&限制&准限制卡表")
}

// 展示卡组
func getDeckViewEntity(deckName: String, titleName: String) -> DeckViewEntity {
    let deckViewEntity = DeckViewEntity()
    deckViewEntity.id = deckName
    deckViewEntity.title = titleName
    deckViewEntity.introduction = titleName
    var deckEntitys = [String: [DeckEntity]]()
    //主卡组 0
    //禁止卡 3
    deckEntitys["0"] = []
    //副卡组 1
    //限制卡 4
    deckEntitys["1"] = []
    //额外卡组 2
    //准限制卡 5
    deckEntitys["2"] = []
    //
    do {
        for each in try getDB().prepare("select b.id, a.type, a.number from deck a inner join info b on a.password = b.password where deckName = \"\(deckName)\"") {
            let d = DeckEntity()
            d.id = each[0] as! String
            let type = each[1] as! NSString
            if type.integerValue > 2 {
                d.type = String(type.integerValue - 3)
                deckViewEntity.type = "ban"
            } else {
                d.type = each[1] as! String
            }
            d.number = Int(truncating: each[2] as! NSNumber)
            deckEntitys[d.type]!.append(d)
        }
    } catch {
        print(error.localizedDescription)
    }
    deckViewEntity.deckEntitys = deckEntitys
    return deckViewEntity
}


//设置图片
func setImage(card: UIImageView, id: String, completionHandler: ((Result) -> Void)? = nil) {
    
    let url = getCardUrl(id: id)
    
    card.kf.setImage(with: URL(string: url),
                          placeholder: UIImage(named: "defaultimg"),
                          options: [
                            .scaleFactor(UIScreen.main.scale),
                            .transition(.fade(0.1)),
                            .cacheOriginalImage]
    )
}

/**
 0 a.id,
 1 a.titleChinese,
 2 a.titleJapanese,
 3 a.titleEnglish,
 4 a.type,
 5 a.password,
 6 a.usage,
 7 a.race,
 8 a.property,
 9 a.star,
 10 a.attack,
 11 a.defense,
 12 a.rare,
 13 a.effect,
 14 a.pack,
 15 a.scale,
 16 a.adjust,
 17 b.id,
 18 b.name,
 19 b.type,
 20 b.desc,
 21 b.atk,
 22 b.def,
 23 b.level,
 24 b.race,
 25 b.attribute,
 26 b.archetype,
 27 b.scale,
 28 b.linkval,
 29 b.linkmarkers,
 30 b.card_sets,
 31 b.card_images,
 32 b.card_prices,
 32 b.banlist_info
 **/
//
//构建卡片结构
func buildCardEntity(element: [Binding?]) -> CardEntity {
    let cardEntity = CardEntity()
    //中文id
    cardEntity.id = element[0] as? String
    //中文名称
    cardEntity.titleChinese = element[1] as? String
    //日文名称
    cardEntity.titleJapanese = element[2] as? String
    //英文名称
    cardEntity.titleEnglish = (element[18] != nil ? element[18] : element[3]) as? String
    //类型，
    cardEntity.type = element[4] as? String
    //密码，唯一
    cardEntity.password = element[5] as? String
    //无限制，禁止卡，限制，准限制
    cardEntity.usage = getUsage(id: cardEntity.id)
    //种族，鸟兽，念动力，等等
    cardEntity.race = element[7] as? String
    //属性，光，暗，风，等灯
    cardEntity.property = element[8] as? String
    //星级
    cardEntity.star = element[9] as? String
    //攻击力
    cardEntity.attack = element[10] as? String
    //防御力
    cardEntity.defense = element[11] as? String
    //稀有程度
    cardEntity.rare = element[12] as? String
    //效果
    cardEntity.effect = element[13] as? String
    //卡包
    cardEntity.pack = element[14] as? String
    //灵摆
    cardEntity.scale = element[27] as? String
    //调整
    cardEntity.adjust = element[16] as? String
    //连接
    cardEntity.link = element[28] as? String
    //连接标记
    cardEntity.linkMarker = element[29] as? String
    //
    return cardEntity
}

//获取当前卡牌的使用范围
func getUsage(id: String) -> String {
    //常量池计算
    for deck in deckViewEntitysConstant[1].deckEntitys["0"]! {
        if id == deck.id {
            return "禁止卡"
        }
    }
    //常量池计算
    for deck in deckViewEntitysConstant[1].deckEntitys["1"]! {
        if id == deck.id {
            return "限制卡"
        }
    }
    //常量池计算
    for deck in deckViewEntitysConstant[1].deckEntitys["2"]! {
        if id == deck.id {
            return "准限制卡"
        }
    }
    //默认值
    return "无限制"
    
}


//获取分享时候使用的小图
func getShareViewImage(v: UIView) -> UIImage {
    let w = v.frame.width
    let h = v.frame.height
    let size = CGSize(width: w, height: h)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    v.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return image
}

//判断当前是否iphonex，做特殊处理
func isIPhoneX() -> Bool {
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 2436:
            return true
        case 2688:
            return true
        case 1792:
            return true
        default:
            return false
        }
    }
    return false
}
