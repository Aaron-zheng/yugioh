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

class CardDetailViewController: UIViewController {
    
    @IBOutlet weak var card: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var effect: UIVerticalAlignLabel!
    @IBOutlet weak var star: UIButton!
    @IBOutlet weak var attack: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    var cardEntity: CardEntity!
    var frameWidth: CGFloat!
    
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = greyColor
        
        let h1 = preCalculateTextHeight(text: cardEntity.effect, font: effect.font, width: (frameWidth - materialGap * 2) / 3 * 2 - materialGap * 2)
        let h2 = (frameWidth - materialGap * 2) / 3 / 160 * 230 - materialGap * 7.5
        if h1 > h2 {
            self.heightConstraint.constant = h1 - h2
        }
        prepare()
        
        
    }
    
    
    
    
    public func prepare() {
        let img = UIImage(named: "ic_star_white")?.withRenderingMode(.alwaysTemplate)
        star.setImage(img, for: .normal)
        star.tintColor = greyColor
        star.isHidden = true
        
        
        self.name.text = cardEntity.title
        self.effect.text = cardEntity.effect
        if cardEntity.star.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            self.type.text = cardEntity.type + " (" + cardEntity.star + "星)"
        } else {
            self.type.text = cardEntity.type
        }
        if cardEntity.attack.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 && cardEntity.defense.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            self.attack.text = cardEntity.attack + " / " + cardEntity.defense
        } else {
            self.attack.text = ""
        }
        
        setImage(card: self.card, url: cardEntity.url)
                

    }
    
    
   }
