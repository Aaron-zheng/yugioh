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

//获取图片详细链接
func getCardUrl(password: String) -> String {
    return qiniuUrlPrefix + "jp/" + password + qiniuUrlSuffix
}

//获取卡牌详情
func getCardEntity(id: String) -> CardEntity {
    do {
        for each in try getDB().prepare("select * from info where id = \"\(id)\"") {
            return buildCardEntity(element: each)
        }
    } catch {
        print(error.localizedDescription)
    }
    return CardEntity()
}

func getChampionDeckViewEntity(deckName: String) -> DeckViewEntity {
    return getDeckViewEntity(deckName: deckName, titleName: deckName + "游戏王世界锦标赛冠军卡组")
}

func getDeckViewEntity(deckName: String, titleName: String) -> DeckViewEntity {
    let deckViewEntity = DeckViewEntity()
    deckViewEntity.id = deckName
    deckViewEntity.title = titleName
    deckViewEntity.introduction = titleName
    var deckEntitys = [String: [DeckEntity]]()
    deckEntitys["0"] = []
    deckEntitys["1"] = []
    deckEntitys["2"] = []
    do {
        for each in try getDB().prepare("select b.id, a.type, a.number from deck a inner join info b on a.password = b.password where deckName = \"\(deckName)\"") {
            let d = DeckEntity()
            d.id = each[0] as! String
            d.type = each[1] as! String
            d.number = Int(truncating: each[2] as! NSNumber)
            deckEntitys[d.type]!.append(d)
        }
    } catch {
        print(error.localizedDescription)
    }
    deckViewEntity.deckEntitys = deckEntitys
    return deckViewEntity
}


//获取
fileprivate func extractedFunc(_ id: String) -> String {
    return getCardUrl(id: id)
}
//设置图片
func setImage(card: UIImageView, id: String) {
    
    let url = extractedFunc(id)
    
    card.kf.setImage(with: URL(string: url),
                          placeholder: UIImage(named: "defaultimg"),
                          options: [.transition(.fade(0.1))],
                          progressBlock: { receivedSize, totalSize in
        },
                          completionHandler: { image, error, cacheType, imageURL in
                            
    })
}

func buildDeckViewEntity(element: [Binding?]) -> DeckViewEntity {
    let deckViewEntity = DeckViewEntity();
    
    return deckViewEntity
}



func buildCardEntity(element: [Binding?]) -> CardEntity {
    let cardEntity = CardEntity()
    cardEntity.id = element[0] as? String
    cardEntity.titleChinese = element[1] as? String
    cardEntity.titleJapanese = element[2] as? String
    cardEntity.titleEnglish = element[3] as? String
    cardEntity.type = element[4] as? String
    cardEntity.password = element[5] as? String
    cardEntity.usage = element[6] as? String
    cardEntity.race = element[7] as? String
    cardEntity.property = element[8] as? String
    cardEntity.star = element[9] as? String
    cardEntity.attack = element[10] as? String
    cardEntity.defense = element[11] as? String
    cardEntity.rare = element[12] as? String
    cardEntity.effect = element[13] as? String
    cardEntity.pack = element[14] as? String
    cardEntity.scale = element[15] as? String
    cardEntity.adjust = element[16] as? String 
    return cardEntity
}

//获取当前卡牌的使用范围
func getUsage(id: String) -> String {
    
    for deck in deckViewEntitysConstant[1].deckEntitys["0"]! {
        if id == deck.id {
            return yearAndMonthLimitConstant + "禁止卡"
        }
    }
    
    for deck in deckViewEntitysConstant[2].deckEntitys["0"]! {
        if id == deck.id {
            return yearAndMonthLimitConstant + "限制卡"
        }
    }
    
    for deck in deckViewEntitysConstant[3].deckEntitys["0"]! {
        if id == deck.id {
            return yearAndMonthLimitConstant + "准限制卡"
        }
    }
    
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
