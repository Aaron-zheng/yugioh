//
//  Constant.swift
//  yugioh
//
//  Created by Aaron on 24/9/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit
import SQLite

public let materialGap: CGFloat = 8
public let redColor = UIColor(red: 237 / 255.0, green: 65 / 255.0, blue: 45 / 255.0, alpha: 1.0)
public let blueColor = UIColor(red: 62 / 255.0, green: 130 / 255.0, blue: 247 / 255.0, alpha: 1.0)
public let greenColor = UIColor(red: 45 / 255.0, green: 169 / 255.0, blue: 79 / 255.0, alpha: 1.0)
public let yellowColor = UIColor(red: 253 / 255.0, green: 189 / 255.0, blue: 0.0, alpha: 1.0)
public let greyColor = UIColor(red: 238 / 255.0, green: 238 / 255.0, blue: 238 / 255.0, alpha: 1.0)
public let darkColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)


public let navigationBarTitleText = "游戏王卡牌"


public let tabBarItemCard = "卡牌"
public let tabBarItemStar = "收藏"
public let tabBarItemSetting = "关于"

public let qiniuUrlPrefix: String = "http://yugioh.oss-cn-beijing.aliyuncs.com/yugiohnewpro/en/"
public let qiniuUrlSuffix: String = ".jpg"

//wechat id
public let wechatKey: String = "wx13153ecd85ee39a9"


public let nc = NotificationCenter.default

extension Notification.Name {
    static let NOTIFICATION_NAME_LANGUAGE_CHANGE = Notification.Name("notification_name_language_change")
}



//font
//0.87 0.54 0.38
//16 14 12
//roboto medium light



private let path = Bundle.main.path(forResource: "cards", ofType: "cdb")
private var db: Connection?
public func getDB() -> Connection {
    if db == nil {
        do {
            db = try Connection(path!)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    return db!
}


