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
    @IBOutlet weak var usage: UIVerticalAlignLabel!
    @IBOutlet weak var star: DOFavoriteButton!
    @IBOutlet weak var attack: UILabel!
    @IBOutlet weak var property: UILabel!
    @IBOutlet weak var effect: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var packageSet: UILabel!
    @IBOutlet weak var adjust: UIVerticalAlignLabel!
    @IBOutlet weak var startDate: UILabel!
    
    //
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    //浮动按钮
    @IBOutlet weak var floatyButton: Floaty!
    
    @IBOutlet weak var contentView: UIImageView!
    
    @IBOutlet weak var innerViewHeader: NSLayoutConstraint!
    
    @IBOutlet weak var adjustView: UIView!
    
    
    //
    var cardEntity: CardEntity!
    var proxy: UIScrollView!
    
    fileprivate var deckService: DeckService = DeckService()
    fileprivate var cardService: CardService = CardService()
    
    
    override func viewDidLoad() {
        self.contentView.backgroundColor = greyColor
        
        //如果是iphonex 则高度需要改变
        if isIPhoneX() {
            innerViewHeader.constant = 96
        }
    
        self.view.backgroundColor = UIColor.clear
        let frameWidth = self.proxy.frame.width
        
        
        //卡牌最高度
        let h0 = (frameWidth - materialGap * 2) / 3 / 160 * 230
        //效果高度
        let h1 = preCalculateTextHeight(text: cardEntity.getDesc(), font: effect.font, width: (frameWidth - materialGap * 2) / 3 * 2 - materialGap * 2)
        //卡包高度
//        var h2 = preCalculateTextHeight(text: cardEntity.getName(), font: effect.font, width: (frameWidth - materialGap * 2) / 3 * 2 - materialGap * 2)
//        if h2 < 16 {
//            h2 = 16
//        }
        //总高度
        //头部gap8 + title24 + type16 + property16 + effect + gap4 + password16 + pack + gap8
        let h3 = 8 + 24 + 16 + 16 + h1 + 4 + 16 + 16 + 8
        
        
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
        
        self.name.text = cardEntity.getName()
        self.effect.text = cardEntity.getDesc()
        self.type.text = cardEntity.getType()
        self.usage.text = cardEntity.getBanlistInfoText()
        
        
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
        
        self.password.text = "ID: " + cardEntity.getId()
        self.startDate.text = cardEntity.getStartDate()
        
        if cardEntity.getScale() != "" {
//            self.extra.text = "灵摆: " + cardEntity.scale
        }
        
        //灵摆和连接 不可能同时存在，所以使用共同的label展示好了
        if cardEntity.getLinkval() != "" {
//            self.extra.text = "连接: " + cardEntity.getLinkval() + " "
//                + cardEntity.getLinkmarkers()
//                    .replacingOccurrences(of: "\"", with: "")
//                    .replacingOccurrences(of: "-", with: "")
//                    .replacingOccurrences(of: "Top", with: "上")
//                    .replacingOccurrences(of: "Bottom", with: "下")
//                    .replacingOccurrences(of: "Left", with: "左")
//                    .replacingOccurrences(of: "Right", with: "右")
        }
        self.packageSet.text = "卡包: 暂无" // + cardEntity.getCardSets()
        // 设置调整
        self.adjust.text = ""
        // 设置调整界面直接隐藏
        self.adjustView.isHidden = true
        
        
        
        let url = getCardUrl(id: cardEntity.id)
        self.card.kf.setImage(with: URL(string: url),
                         placeholder: UIImage(named: "defaultimg"),
                         options: [
                            .scaleFactor(UIScreen.main.scale),
                            .transition(.fade(0.1)),
                            .cacheOriginalImage]
        )
        
        
        
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
        
    }
    
    
    private func addPropertyText(paddingText: String!) {
        if self.property.text! != "" {
            self.property.text! += " / ";
        }
        self.property.text! += paddingText;
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
    
}

extension CardDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
