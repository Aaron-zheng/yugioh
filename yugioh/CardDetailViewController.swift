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
import Floaty


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
    
    @IBOutlet weak var floatyButton: Floaty!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBOutlet weak var commentInputTextField: UITextField!

    
    //
    var cardEntity: CardEntity!
    var commentEntitys: Array<CommentEntity>! = []
    var proxy: UIScrollView!
    
    fileprivate var deckService: DeckService = DeckService()
    fileprivate var cardService: CardService = CardService()
    
    fileprivate var commentDAO = CommentService()
    
    
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
        
        
        
        floatyButton.buttonColor = redColor
        floatyButton.plusColor = UIColor.white
        floatyButton.overlayColor = UIColor.clear
        floatyButton.itemShadowColor = UIColor.clear
        floatyButton.itemImageColor = UIColor.clear
        floatyButton.itemTitleColor = UIColor.clear
        floatyButton.itemButtonColor = UIColor.clear
        floatyButton.tintColor = UIColor.clear
        
        
        let negImg = UIImage(named: "ic_account_balance_wallet_white")?.withRenderingMode(.alwaysTemplate)
        let item1 = FloatyItem()
        item1.buttonColor = UIColor.white
        item1.iconTintColor = UIColor.black.withAlphaComponent(0.12)
        item1.circleShadowColor = UIColor.clear
        item1.titleShadowColor = UIColor.clear
        item1.title = "卡组-1"
        item1.titleColor = UIColor.black.withAlphaComponent(0.38)
        item1.icon = negImg
        item1.tintColor = UIColor.clear
        item1.itemBackgroundColor = UIColor.clear
        item1.backgroundColor = UIColor.clear
        item1.handler = {
            item in
            self.deckService.delete(id: self.cardEntity.id)
        }
        
        let pluImg = UIImage(named: "ic_account_balance_wallet_white")?.withRenderingMode(.alwaysTemplate)
        let item2 = FloatyItem()
        item2.buttonColor = UIColor.white
        item2.iconTintColor = UIColor.black.withAlphaComponent(0.38)
        item2.circleShadowColor = UIColor.clear
        item2.titleShadowColor = UIColor.clear
        item2.title = "卡组+1"
        item2.titleColor = UIColor.black.withAlphaComponent(0.38)
        item2.icon = pluImg
        item2.tintColor = UIColor.clear
        item2.itemBackgroundColor = UIColor.clear
        item2.backgroundColor = UIColor.clear
        item2.handler = {
            item in
            self.deckService.save(id: self.cardEntity.id)
        }
        floatyButton.addItem(item: item1)
        floatyButton.addItem(item: item2)
        
        
        prepareTableView()

        self.commentInputTextField.delegate = self
        
    }
    
    
    func retriveComment() {
        commentDAO.getComment(id: cardEntity.id) { (commentEntitys) in
            self.commentEntitys = commentEntitys
            self.commentCountLabel.text = "评论 (" + commentEntitys.count.description + ")"
            self.tableView.reloadData()
        }
    }
    
    
    private func prepareTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = greyColor
        self.tableView.separatorStyle = .singleLine
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.register(CardCommentTableCell.NibObject(), forCellReuseIdentifier: CardCommentTableCell.identifier())
        
        retriveComment()
    }
}


extension CardDetailViewController: UITableViewDataSource {
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return commentEntitys.count
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CardCommentTableCell.identifier(), for: indexPath) as! CardCommentTableCell
        cell.prepare(commentEntity: commentEntitys[indexPath.row])
        
        return cell
    }
    
}

extension CardDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension CardDetailViewController: UITextFieldDelegate {
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let input = textField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if input != nil && input != "" {
            
            let commentEntity = CommentEntity()
            commentEntity.content = input!
            commentEntity.id = cardEntity.id
            self.commentDAO.addComment(commentEntity: commentEntity, callback: {
                self.retriveComment()
            })
        }
        
        textField.text = ""
        
        return true
    }
    
}


