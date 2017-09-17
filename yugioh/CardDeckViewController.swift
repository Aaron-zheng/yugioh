//
//  CardDeckViewController.swift
//  yugioh
//
//  Created by Aaron on 1/7/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation
import UIKit
import Floaty
import Firebase

class CardDeckViewController: UIViewController {
    
    var rootController: ViewController!
    var deckViewController: DeckViewController!
    var deckViewEntity: DeckViewEntity!
    
    fileprivate var cardEntitys: Array<CardEntity>! = []
    fileprivate var deckService = DeckService()
    
    
    @IBOutlet weak var tableView: UICollectionView!
    @IBOutlet weak var floatyButton: Floaty!
    
    override func viewWillAppear(_ animated: Bool) {
        if deckViewEntity.id == "0" {
            deckViewEntity.deckEntitys = deckService.list()
        }
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        //
        self.cardEntitys = rootController.cardEntitys
        //
        self.tableView.backgroundColor = greyColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CardDeckCollectionViewCell.NibObject(), forCellWithReuseIdentifier: CardDeckCollectionViewCell.identifier())
        //
        prepareFloatyButtion()
        
        
    }
    
    func prepareFloatyButtion() {
        
        floatyButton.buttonColor = redColor
        floatyButton.plusColor = UIColor.white
        floatyButton.overlayColor = UIColor.clear
        floatyButton.itemShadowColor = UIColor.clear
        floatyButton.itemImageColor = UIColor.clear
        floatyButton.itemTitleColor = UIColor.clear
        floatyButton.itemButtonColor = UIColor.clear
        floatyButton.tintColor = UIColor.clear
        
        
        let shareImg = UIImage(named: "ic_share_white")?.withRenderingMode(.alwaysTemplate)
        let item3 = FloatyItem()
        item3.buttonColor = redColor
        item3.iconTintColor = UIColor.white
        item3.circleShadowColor = UIColor.clear
        item3.titleShadowColor = UIColor.clear
        item3.icon = shareImg
        item3.tintColor = UIColor.clear
        item3.itemBackgroundColor = UIColor.clear
        item3.backgroundColor = UIColor.clear
        item3.handler = {
            item in
            var title = "";
            if let t = self.title {
                title = t
            }
            setLog(event: AnalyticsEventShare, description: title)
            let img = self.getShareViewImage()
            let ext = WXImageObject()
            ext.imageData = UIImageJPEGRepresentation(img, 1)
            
            let message = WXMediaMessage()
            message.title = nil
            message.description = nil
            message.mediaObject = ext
            message.mediaTagName = "游戏王卡牌"
            //生成缩略图
            UIGraphicsBeginImageContext(CGSize(width: 100, height: 200))
            img.draw(in: CGRect(x: 0, y: 0, width: 100, height: 200))
            let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            message.thumbData = UIImagePNGRepresentation(thumbImage!)
            
            let req = SendMessageToWXReq()
            req.text = nil
            req.message = message
            req.bText = false
            req.scene = 0
            WXApi.send(req)
        }
        
        
        floatyButton.addItem(item: item3)
    }
    
    
    
    func getShareViewImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(tableView.contentSize, false, 0)
        
        tableView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let row = tableView.numberOfItems(inSection: 0)
        let numberOfRowThatShowInScreen = 4
        let scrollCount = row / numberOfRowThatShowInScreen
        for i in 0 ..< scrollCount {
            let indexPath = IndexPath(row: ( i + 1 ) * numberOfRowThatShowInScreen, section: 0)
            tableView.scrollToItem(at: indexPath, at: .top, animated: false)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        return image
    }
}

extension CardDeckViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = rootController.view.frame.size
        let w = (size.width - 16 - 8) / 2
        let h = (size.height - 50 - 40 - 40 - 16) / 20
        return CGSize.init(width: w, height: h)
        
    }
}

extension CardDeckViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let deckEntity = deckViewEntity.deckEntitys[indexPath.row]
        let cardEntity = getCardEntity(id: deckEntity.id)
        let controller = CardDetailViewController()
        controller.cardEntity = cardEntity
        controller.hidesBottomBarWhenPushed = true
        controller.proxy = self.tableView
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}

extension CardDeckViewController: UICollectionViewDataSource {
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deckViewEntity.deckEntitys.count
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.tableView.dequeueReusableCell(withReuseIdentifier: CardDeckCollectionViewCell.identifier(), for: indexPath) as! CardDeckCollectionViewCell
        
        cell.titleLabel.text = ""
        cell.backgroundColor = UIColor.white
        
        if indexPath.row < deckViewEntity.deckEntitys.count {
            let deckEntity = deckViewEntity.deckEntitys[indexPath.row]
            let cardEntity = getCardEntity(id: deckEntity.id)
            
            if deckViewEntity.id == "forbid" || deckViewEntity.id == "limit1" || deckViewEntity.id == "limit2" {
                cell.titleLabel.text = cardEntity.titleChinese
            } else {
                cell.titleLabel.text = cardEntity.titleChinese + " x " + deckEntity.number.description
            }
            setImage(card: cell.cardImageView, id: cardEntity.id)
        }
        
        
        return cell
    }
}
