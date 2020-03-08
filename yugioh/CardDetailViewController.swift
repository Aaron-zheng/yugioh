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
import Alamofire



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
    @IBOutlet weak var adjust: UIVerticalAlignLabel!
    @IBOutlet weak var scale: UILabel!
    @IBOutlet weak var link: UILabel!
    
    //
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var floatyButton: Floaty!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBOutlet weak var commentInputTextField: UITextField!

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var innerViewHeader: NSLayoutConstraint!
    //
    var cardEntity: CardEntity!
    var commentEntitys: Array<CommentEntity>! = []
    var proxy: UIScrollView!
    
    fileprivate var deckService: DeckService = DeckService()
    fileprivate var cardService: CardService = CardService()
    
    fileprivate var commentDAO = CommentService()
    
    private func setImageView() {
        let img = card.image
        print(self.contentView.bounds)
        let view = UIImageView(frame: self.contentView.bounds)
        view.image = img
//        view.layer.cornerRadius = 0
//        view.layer.masksToBounds = true
        view.backgroundColor = redColor
        self.contentView.addSubview(view)
    }
    
    
    override func viewDidLoad() {
        //如果是iphonex 则高度需要改变
        if isIPhoneX() {
            innerViewHeader.constant = 96
        }
        
        //TODO 需要修改的部分
        self.contentView.backgroundColor = greyColor
        self.view.backgroundColor = greyColor
        let frameWidth = self.proxy.frame.width
        self.pack.verticalAligment = .VerticalAligmentBottom
        
        print(cardEntity.effect.count)
        //卡牌最高度
        let h0 = (frameWidth - materialGap * 2) / 3 / 160 * 230
        //效果高度
        let h1 = preCalculateTextHeight(text: cardEntity.effect, font: effect.font, width: (frameWidth - materialGap * 2) / 3 * 2 - materialGap * 2)
        //卡包高度
        var h2 = preCalculateTextHeight(text: cardEntity.pack, font: effect.font, width: (frameWidth - materialGap * 2) / 3 * 2 - materialGap * 2)
        if h2 < 16 {
            h2 = 16
        }
        //总高度
        //头部gap8 + title24 + type16 + property16 + effect + gap4 + password16 + pack + rare + gap8
        let h3 = 8 + 24 + 16 + 16 + h1 + 4 + 16 + h2 + 16 + 8
        
        
        if h0 > h3 {
            self.heightConstraint.constant = h0
        } else {
            self.heightConstraint.constant = h3
        }
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CardDetailViewController.imageTapped(tapGestureRecognizer:)))
        card.isUserInteractionEnabled = true
        card.addGestureRecognizer(tapGestureRecognizer)
        
        prepare()
        
        
        
        let shareButton = UIBarButtonItem.init(
            title: "分享",
            style: .done,
            target: self,
            action: #selector(CardDetailViewController.shareButtonHandler)
        )
        
        self.navigationItem.rightBarButtonItem = shareButton

    }
    
    
    @objc func shareButtonHandler() {
        let img = getShareViewImage(v: innerView)
        let ext = WXImageObject()
        ext.imageData = img.jpegData(compressionQuality: 1)!
        
        
        let message = WXMediaMessage()
        message.title = ""
        message.description = ""
        message.mediaObject = ext
        message.mediaTagName = "游戏王卡牌"
        //生成缩略图
        UIGraphicsBeginImageContext(CGSize(width: 100, height: 50))
        img.draw(in: CGRect(x: 0, y: 0, width: 100, height: 50))
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        message.thumbData = thumbImage!.pngData()
        
        let req = SendMessageToWXReq()
        req.text = ""
        req.message = message
        req.bText = false
        req.scene = 0
        WXApi.send(req)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let agrume = Agrume(image: self.card.image!)
        agrume.hideStatusBar = true
        agrume.show(from: self)
    }
    
    
    
    @IBAction func clickStarButton(_ sender: DOFavoriteButton) {
        //setLog(event: AnalyticsEventAddToCart, description: cardEntity.id)
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
        
        
        self.property.text = ""
        self.property.text = self.property.text! + cardEntity.property
        if cardEntity.race != "" {
            self.property.text = self.property.text! + " / "
            self.property.text = self.property.text! + cardEntity.race
        }
        if cardEntity.star != "" {
            self.property.text = self.property.text! + " / "
            self.property.text = self.property.text! + cardEntity.star + "星"
        }
        
        if !cardEntity.attack.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.attack.text = cardEntity.attack
        } else {
            self.attack.text = ""
        }
        if !cardEntity.defense.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.attack.text = self.attack.text! + " / " + cardEntity.defense
        }
        
        self.password.text = "编号: " + cardEntity.password
        if cardEntity.scale != nil && !cardEntity.scale.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.scale.text = "灵摆: " + cardEntity.scale
        } else {
            self.scale.text = ""
        }
        
        if cardEntity.link != nil {
            self.link.text = "连接: " + cardEntity.link + " "
                + cardEntity.linkMarker
                    .replacingOccurrences(of: "\"", with: "")
                    .replacingOccurrences(of: "-", with: "")
                    .replacingOccurrences(of: "Top", with: "上")
                    .replacingOccurrences(of: "Bottom", with: "下")
                    .replacingOccurrences(of: "Left", with: "左")
                    .replacingOccurrences(of: "Right", with: "右")
        } else {
            self.link.text = ""
        }
        
        self.rare.text = "卡牌: " + cardEntity.rare
        self.pack.text = "卡包: " + cardEntity.pack
        if cardEntity.adjust == "" {
            self.adjust.text = "调整: 无"
        } else {
            self.adjust.text = "调整: " + cardEntity.adjust
        }
        
        
        
        setImage(card: self.card, id: cardEntity.id)
        
        
        
        floatyButton.buttonColor = redColor
        floatyButton.plusColor = UIColor.white
        floatyButton.overlayColor = UIColor.clear
        floatyButton.itemShadowColor = UIColor.clear
        floatyButton.itemImageColor = UIColor.clear
        floatyButton.itemTitleColor = UIColor.clear
        floatyButton.itemButtonColor = UIColor.clear
        floatyButton.tintColor = UIColor.clear
        
        
        
        let negImg = UIImage(named: "ic_exposure_neg_1_white")?.withRenderingMode(.alwaysTemplate)
        let item1 = FloatyItem()
        item1.buttonColor = redColor
        item1.iconTintColor = UIColor.white
        item1.circleShadowColor = UIColor.clear
        item1.titleShadowColor = UIColor.clear
        item1.icon = negImg
        item1.tintColor = UIColor.clear
        item1.itemBackgroundColor = UIColor.clear
        item1.backgroundColor = UIColor.clear
        item1.handler = {
            item in
            self.cardInsertSelection(id: self.cardEntity.id, type: "del")
        }
        
        let pluImg = UIImage(named: "ic_exposure_plus_1_white")?.withRenderingMode(.alwaysTemplate)
        let item2 = FloatyItem()
        item2.buttonColor = redColor
        item2.iconTintColor = UIColor.white
        item2.circleShadowColor = UIColor.clear
        item2.titleShadowColor = UIColor.clear
        item2.icon = pluImg
        item2.tintColor = UIColor.clear
        item2.itemBackgroundColor = UIColor.clear
        item2.backgroundColor = UIColor.clear
        item2.handler = {
            item in
            self.cardInsertSelection(id: self.cardEntity.id, type: "add")
        }
        
        
        
        floatyButton.addItem(item: item1)
        floatyButton.addItem(item: item2)
        
        
        
        prepareTableView()

        self.commentInputTextField.delegate = self
        
    }
    
    
    func cardInsertSelection(id: String, type: String) {
        
        var typeTitle = ""
        var isAdd = true
        
        if type == "add" {
            typeTitle = "添加"
            isAdd = true
        } else if type == "del" {
            typeTitle = "删除"
            isAdd = false
        }
        
        let alertController = UIAlertController(title: typeTitle + "操作", message: "我的卡组中" + typeTitle + "，选择：", preferredStyle: .actionSheet)
        
        let mainButton = UIAlertAction(title: "主卡组", style: .default, handler: { (action) -> Void in
            if isAdd {
                self.deckService.save(id: id, type: "0")
            } else {
                self.deckService.delete(id: id, type: "0")
            }
        })
        
        let viceButton = UIAlertAction(title: "副卡组", style: .default, handler: { (action) -> Void in
            if isAdd {
                self.deckService.save(id: id, type: "1")
            } else {
                self.deckService.delete(id: id, type: "1")
            }
        })
        
        let extraButton = UIAlertAction(title: "额外卡组", style: .default, handler: { (action) -> Void in
            if isAdd {
                self.deckService.save(id: id, type: "2")
            } else {
                self.deckService.delete(id: id, type: "2")
            }
        })
        
        let cancelButton = UIAlertAction(title: "取消", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(mainButton)
        alertController.addAction(viceButton)
        alertController.addAction(extraButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
        
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

