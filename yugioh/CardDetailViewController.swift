//
//  CardDetailViewController.swift
//  yugioh
//
//  Created by Aaron on 25/10/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Agrume


class CardDetailViewController: UIViewController {
    //first part
    @IBOutlet weak var card: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var effect: UIVerticalAlignLabel!
    @IBOutlet weak var star: DOFavoriteButton!
    @IBOutlet weak var attack: UILabel!
    @IBOutlet weak var pack: UIVerticalAlignLabel!
    @IBOutlet weak var property: UILabel!
    @IBOutlet weak var usage: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var rare: UILabel!
    
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    
    
    //
    var cardEntity: CardEntity!
    var commentEntitys: Array<CommentEntity>! = []
    var proxy: UIScrollView!
    
    fileprivate var deckService: DeckService = DeckService()
    fileprivate var cardService: CardService = CardService()
    
//    fileprivate var commentDAO = CommentService()
    
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = greyColor
        let frameWidth = self.proxy.frame.width
        self.pack.verticalAligment = .VerticalAligmentBottom
        
        
        
        
        //卡牌最高度
        let h0 = (frameWidth - materialGap * 2) / 3 / 160 * 230
        //效果高度
        let h1 = preCalculateTextHeight(text: cardEntity.effect, font: effect.font, width: (frameWidth - materialGap * 2) / 3 * 2 - materialGap * 2)
        //卡包高度
        let h2 = preCalculateTextHeight(text: cardEntity.pack, font: effect.font, width: (frameWidth - materialGap * 2) / 3 * 2 - materialGap * 2)
        //总高度
        let h3 = 8 + 24 + 16 + 16 + h1 + 8 + 16 + h2 + 8
        
        
        if h0 > h3 {
            self.heightConstraint.constant = h0
        } else {
            self.heightConstraint.constant = h3
        }
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CardDetailViewController.imageTapped(tapGestureRecognizer:)))
        card.isUserInteractionEnabled = true
        card.addGestureRecognizer(tapGestureRecognizer)
        
        prepare()
        
        
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let agrume = Agrume(image: card.image!, backgroundColor: .black)
        agrume.hideStatusBar = true
        agrume.showFrom(self)
    }
    
    
    @IBAction func clickDeckDeleteButton(_ sender: Any) {
        deckService.delete(id: cardEntity.id)
    }
    
    
    @IBAction func clickDeckButton(_ sender: UIButton) {
        deckService.save(id: cardEntity.id)
    }
    
    @IBAction func clickStarButton(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            cardEntity.isSelected = false
            cardService.delete(id: cardEntity.id)
            sender.deselect()
        } else {
            cardEntity.isSelected = true
            cardService.save(id: cardEntity.id)
            sender.select()
        }

    }
    
    
    public func prepare() {
        //star button
        let img = UIImage(named: "ic_star_white")?.withRenderingMode(.alwaysTemplate)
        star.imageColorOn = yellowColor
        star.imageColorOff = greyColor
        star.image = img
        if cardEntity.isSelected {
            star.selectWithNoCATransaction()
        } else {
            star.deselect()
        }
        
        
        
        self.name.text = cardEntity.titleChinese
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
        self.password.text = ""
        self.rare.text = "卡牌: " + cardEntity.rare
        self.pack.text = "卡包: " + cardEntity.pack
        
        
        setImage(card: self.card, url: cardEntity.url)
        
    }
    
    
}

