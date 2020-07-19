//
//  UIVerticalAlignLabel.swift
//  swifttips
//
//  Created by Aaron on 25/7/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

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
        for each in try getDB().prepare("select b.id, b.name, b.type, b.desc, b.atk, b.def, b.level, b.race, b.attribute, b.archetype, b.scale, b.linkval, b.linkmarkers, b.card_sets, b.card_images, b.card_prices, b.banlist_info from  pro b where language = 'cn' order by id desc") {
            cardEntitys.append(buildCardEntity(element: each))
        }
        
        
    } catch {
        print(error.localizedDescription)
    }
    
    return cardEntitys
}

func getCardEntity(cardSet: String) -> Array<CardEntity> {
    var cardEntitys: Array<CardEntity> = []
    do {
        for each in try getDB().prepare("select a.id, a.titleChinese, a.titleJapanese, a.titleEnglish, a.type, a.password, a.usage, a.race, a.property, a.star, a.attack, a.defense, a.rare, a.effect, a.pack, a.scale, a.adjust, b.id, b.name, b.type, b.desc, b.atk, b.def, b.level, b.race, b.attribute, b.archetype, b.scale, b.linkval, b.linkmarkers, b.card_sets, b.card_images, b.card_prices, b.banlist_info from info a left outer join pro b on a.password = b.id where b.card_sets like '%\(cardSet)%' order by (a.id+0) desc") {
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
        for each in try getDB().prepare("select to_char(a.id), a.titleChinese, a.titleJapanese, a.titleEnglish, a.type, a.password, a.usage, a.race, a.property, a.star, a.attack, a.defense, a.rare, a.effect, a.pack, a.scale, a.adjust, b.id, b.name, b.type, b.desc, b.atk, b.def, b.level, b.race, b.attribute, b.archetype, b.scale, b.linkval, b.linkmarkers, b.card_sets, b.card_images, b.card_prices, b.banlist_info from info a left outer join pro b on a.password = b.id where a.id = \"\(id)\"") {
            return buildCardEntity(element: each)
        }
    } catch {
        print(error.localizedDescription)
    }
    return CardEntity()
}

//获取冠军卡组
func getChampionDeckViewEntity(deckName: String) -> DeckViewEntity {
    return getDeckViewEntity(deckName: deckName, titleName: deckName + "游戏王世界锦标赛冠军卡组", type: "champion")
}
//获取禁卡组
func getBanDeckViewEntity(deckName: String) -> DeckViewEntity {
    return getDeckViewEntity(deckName: deckName, titleName: "2020年1月" + deckName + "卡表[禁止/限制/准限制]", type: "ban")
}

private var deckViewEntitysConstant: [DeckViewEntity] = [];
func getDeckViewEntity() -> [DeckViewEntity] {
    if(deckViewEntitysConstant.count > 0) {
        return deckViewEntitysConstant
    }
    
    var tmp: [DeckViewEntity] = [
        DeckViewEntity(id: "0", title: "我的卡组", introduction: "我的卡组", type: "self"),
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

    
    do {
        for each in try getDB().prepare("select set_name, date, num_of_cards, set_code from cardset order by date desc") {
            let deckViewEntity = DeckViewEntity()
            let setName = each[0] as! String
            let date = each[1] as! String
            let numOfCards = each[2] as! Number
            let setCode = each[3] as! String
            deckViewEntity.id = setName
            deckViewEntity.title = "\(date) \(setCode) 卡包（\(numOfCards)）"
            deckViewEntity.type = "cardset"
            tmp.append(deckViewEntity)
        }
    } catch {
        print(error.localizedDescription)
    }
    deckViewEntitysConstant = tmp
    return deckViewEntitysConstant
}


// 展示卡组
func getDeckViewEntity(deckName: String, titleName: String, type: String) -> DeckViewEntity {
    let deckViewEntity = DeckViewEntity()
    deckViewEntity.id = deckName
    deckViewEntity.title = titleName
    deckViewEntity.introduction = titleName
    deckViewEntity.type = type
    return deckViewEntity
}

func getDeckEntityFromCardSet(setName: String) -> [String: [DeckEntity]]{
    var deckEntitys = [String: [DeckEntity]]()
    deckEntitys["0"] = []
    let cardEntitys: Array<CardEntity> = getCardEntity(cardSet: setName)
    for each in cardEntitys {
        let d = DeckEntity()
        d.id = each.id
        d.number = 1
        d.type = "0"
        deckEntitys["0"]?.append(d)
    }
    return deckEntitys
}


func getDeckEntity(deckName: String) -> [String: [DeckEntity]]{
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
            } else {
                d.type = each[1] as! String
            }
            d.number = Int(truncating: each[2] as! NSNumber)
            deckEntitys[d.type]!.append(d)
        }
    } catch {
        print(error.localizedDescription)
    }
    return deckEntitys
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
 0 b.id,
 1 b.name,
 2 b.type,
 3 b.desc,
 4 b.atk,
 5 b.def,
 6 b.level,
 7 b.race,
 8 b.attribute,
 9 b.archetype,
 10 b.scale,
 11 b.linkval,
 12 b.linkmarkers,
 13 b.card_sets,
 14 b.card_images,
 15 b.card_prices,
 16 b.banlist_info
 **/
//
//构建卡片结构
func buildCardEntity(element: [Binding?]) -> CardEntity {
    let cardEntity = CardEntity()
    //password
    cardEntity.id = String(element[0] as! Int64)
    //中文名称
    cardEntity.titleChinese = element[1] as? String
    //类型，
    cardEntity.type = element[2] as? String
    //效果
    cardEntity.effect = element[3] as? String
    //密码，唯一
    cardEntity.password = String(element[0] as! Int64)
    //无限制，禁止卡，限制，准限制
//    cardEntity.usage = getUsage(id: cardEntity.id)
    //攻击力
    cardEntity.attack = element[4] as? String
    //防御力
    cardEntity.defense = element[5] as? String
    //星级
    cardEntity.star = element[6] as? String
    //种族，鸟兽，念动力，等等
    cardEntity.race = element[7] as? String
    //属性，光，暗，风，等灯
    cardEntity.property = element[8] as? String
    //稀有程度
    cardEntity.rare = ""
    //卡包
    cardEntity.pack = ""
    //    cardEntity.pack = getPack(s: element[30] as? String)
    //灵摆
    cardEntity.scale = element[10] as? String
    //调整
    cardEntity.adjust = ""
    //连接
    cardEntity.link = element[11] as? String
    //连接标记
    cardEntity.linkMarker = element[12] as? String
    //
    return cardEntity
}

func getPack(s : String?) -> String {
    if let tmp = s?.data(using: .utf8, allowLossyConversion: false) {
        do {
            let json = try JSON(data: tmp)
            var cardSet = ""
            for(_, subJson):(String, JSON) in json {
                if(cardSet != "") {
                    cardSet += ","
                }
                cardSet = "\(cardSet)\(subJson["set_code"])"
            }
            return cardSet
        } catch {
            print("ERROR \(error)")
        }
    }
    
    return ""
}

//获取当前卡牌的使用范围
func getUsage(id: String) -> String {
    // TODO
    return "无限制"
    
    /*
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
    */
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
