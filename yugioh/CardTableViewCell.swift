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
        
        
        self.title.text = cardEntity.titleChinese
        self.effect.text = cardEntity.effect
        self.type.text = cardEntity.type
        self.usage.text = cardEntity.usage
        
        if cardEntity.star.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            self.property.text = ""
                + cardEntity.property
                + " / "
                + cardEntity.race
                + " / "
                + cardEntity.star + "星"
        } else {
            self.property.text = ""
        }
        if cardEntity.attack.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 && cardEntity.defense.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            self.attack.text = cardEntity.attack + " / " + cardEntity.defense
        } else {
            self.attack.text = ""
        }
    }
    
    @IBAction func clickButton(_ sender: Any) {
        let starButton = sender as! DOFavoriteButton
        let cardEntity = starButton.cardEntity
        
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
