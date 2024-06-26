//
//  CardTableViewCell.swift
//  yugioh
//
//  Created by Aaron on 25/9/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


class CardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellContentInnerView: UIView!
    @IBOutlet weak var card: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var effect: UIVerticalAlignLabel!
    @IBOutlet weak var star: DOFavoriteButton!
    @IBOutlet weak var attack: UILabel!
    @IBOutlet weak var property: UILabel!
    @IBOutlet weak var usage: UILabel!
    @IBOutlet weak var effectConstraint: NSLayoutConstraint!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var startDate: UILabel!
    
    private var tableView: UITableView!
    
    private var cardService = CardService()
    
    var afterDeselect: (() -> Void)?
    
    func prepare(cardEntity: CardEntity, tableView: UITableView, indexPath: IndexPath) {
        
        self.tableView = tableView
        
        let img = UIImage(named: "ic_star_white")?.withRenderingMode(.alwaysTemplate)
        star.imageColorOn = yellowColor
        star.imageColorOff = greyColor
        star.image = img
        if cardEntity.isSelected {
            star.selectWithNoCATransaction()
        } else {
            star.deselect()
        }
        
        star.cardEntity = cardEntity
        
        
        cellContentView.backgroundColor = greyColor
        cellContentInnerView.backgroundColor = UIColor.white
        
        // 标题
        self.title.text = cardEntity.getName()
        // 效果
        self.effect.text = cardEntity.getDesc()
        // 类型
        self.type.text = cardEntity.getType()
        // 限制：从常量池中判断使用范围：禁止，限制，准限制，无限制
        self.usage.text = cardEntity.getBanlistInfoText()
        // 编号
        self.password.text = "ID: " + cardEntity.getId()
        self.startDate.text = cardEntity.getStartDate()
        
        self.property.text = ""
        if cardEntity.getAttribute() != "" {
            addPropertyText(paddingText: cardEntity.getAttribute())
        }
        if cardEntity.getRace() != "" {
            addPropertyText(paddingText: cardEntity.getRace())
        }
        if cardEntity.getLevel() != "" {
            addPropertyText(paddingText: cardEntity.getLevel())
        }
        
        
        if !cardEntity.getAtk().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.attack.text = cardEntity.getAtk()
        } else {
            self.attack.text = ""
        }
        if !cardEntity.getDef().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.attack.text = self.attack.text! + " / " + cardEntity.getDef()
        }
    }
    
    private func addPropertyText(paddingText: String!) {
        if self.property.text! != "" {
            self.property.text! += " / ";
        }
        self.property.text! += paddingText;
    }
    
    @IBAction func clickButton(_ sender: Any) {
        let starButton = sender as! DOFavoriteButton
        let cardEntity = starButton.cardEntity
        
        
        //setLog(event: AnalyticsEventAddToCart, description: cardEntity.id)
        
        if starButton.isSelected {
            cardEntity.isSelected = false
            cardService.delete(id: cardEntity.id)
            starButton.deselect()
            if let f = afterDeselect {
                f()
            }
        } else {
            cardEntity.isSelected = true
            cardService.save(id: cardEntity.id)
            starButton.select()
        }
        
    }
    
    
    
}

fileprivate var key: UInt8 = 0

fileprivate extension UIButton {
    var cardEntity: CardEntity {
        get {
            return objc_getAssociatedObject(self, &key) as! CardEntity
        }
        
        set(value) {
            objc_setAssociatedObject(self, &key, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
