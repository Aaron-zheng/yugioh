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

func getCardUrl(id: String) -> String {
    return qiniuUrlPrefix + id + qiniuUrlSuffix
}

func getCardUrl(password: String) -> String {
    return qiniuUrlPrefix + "jp/" + password + qiniuUrlSuffix
}


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




fileprivate func extractedFunc(_ id: String) -> String {
    return getCardUrl(id: id)
}

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

/*
func setLog(event: String, description: String?) {
    var outputDescription = ""
    if let d = description {
        outputDescription = d
    }
    Analytics.logEvent(event, parameters: ["description": outputDescription])
}
*/


func buildCardEntity(element: [Binding?]) -> CardEntity {
    let cardEntity = CardEntity()
    cardEntity.id = element[0] as! String
    cardEntity.titleChinese = element[1] as! String
    cardEntity.titleJapanese = element[2] as! String
    cardEntity.titleEnglish = element[3] as! String
    cardEntity.type = element[4] as! String
    cardEntity.password = element[5] as! String
    cardEntity.usage = element[6] as! String
    cardEntity.race = element[7] as! String
    cardEntity.property = element[8] as! String
    cardEntity.star = element[9] as! String
    cardEntity.attack = element[10] as! String
    cardEntity.defense = element[11] as! String
    cardEntity.rare = element[12] as! String
    cardEntity.effect = element[13] as! String
    cardEntity.pack = element[14] as! String
    cardEntity.scale = element[15] as! String
    cardEntity.adjust = element[16] as! String 
    return cardEntity
}



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

func isIPhoneX() -> Bool {
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 2436:
            return true
        default:
            return false
        }
    }
    return false
}
