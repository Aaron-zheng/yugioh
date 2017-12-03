//
//  CardDeckViewController.swift
//  yugioh
//
//  Created by Aaron on 1/7/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation
import UIKit



class CardDeckViewController: UIViewController {
    
    var rootController: ViewController!
    var deckViewController: DeckViewController!
    var deckViewEntity: DeckViewEntity!
    
    fileprivate var cardEntitys: Array<CardEntity>! = []
    fileprivate var deckService = DeckService()
    
    @IBOutlet weak var guide: UIImageView!
    
    @IBOutlet weak var tableView: UICollectionView!
    
    //0. 代表我的卡组
    //1. 代表禁止卡组
    //2. 代表冠军卡组
    func cardDeckType() -> Int {
        if deckViewEntity.id == "0" {
            return 0
        } else if deckViewEntity.id == "forbid" || deckViewEntity.id == "limit1" || deckViewEntity.id == "limit2"  {
            return 1
        } else {
            return 2
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.guide.alpha = 0
        
        if self.cardDeckType() == 0 {
            deckViewEntity.deckEntitys = deckService.list()
            if deckViewEntity.deckEntitys.count <= 0 {
                //当前为我的卡组，并且卡牌为0，展示引导页
                self.guide.alpha = 1
            }
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
        self.tableView.register(CardDeckViewSectionHeaderView.NibObject(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CardDeckViewSectionHeaderView.identifier())
        
        //
        let shareButton = UIBarButtonItem.init(
            title: "分享",
            style: .done,
            target: self,
            action: #selector(CardDeckViewController.shareButtonHandler)
        )
        
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc func shareButtonHandler() {
        
        if self.deckViewEntity.deckEntitys.count <= 0 {
            return
        }
        
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
    
    
    func getShareViewImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(tableView.contentSize, false, 0)
        
        tableView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let row = tableView.numberOfItems(inSection: 0)
        let numberOfRowThatShowInScreen = 4
        let scrollCount = row / numberOfRowThatShowInScreen
        for i in 0 ..< scrollCount {
            var row = ( i + 1 ) * numberOfRowThatShowInScreen
            if row > 0 {
                row = row - 1
            }
            let indexPath = IndexPath(row: row, section: 0)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if self.cardDeckType() == 0 {
            return CGSize.init(width: 50, height: 24)
        }
        
        return CGSize.init(width: 50, height: 8)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CardDeckViewSectionHeaderView.identifier(), for: indexPath) as! CardDeckViewSectionHeaderView
        
        if kind == UICollectionElementKindSectionHeader {
            
            v.sectionHeaderLabel.text = ""
            
            if self.cardDeckType() == 0 {
                if indexPath.section == 0 {
                    v.sectionHeaderLabel.text = "主卡组"
                } else if indexPath.section == 1 {
                    v.sectionHeaderLabel.text = "副卡组"
                } else if indexPath.section == 2 {
                    v.sectionHeaderLabel.text = "额外卡组"
                }
            } 
        }
        
        return v
        
    }
    
}

extension CardDeckViewController: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.cardDeckType() == 0 {
            return 3
        } else {
            return 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return deckViewEntity.deckEntitys.count
        } else if section == 1 {
            return deckViewEntity.deckEntitys.count
        } else if section == 2 {
            return deckViewEntity.deckEntitys.count
        } else {
            return 0
        }
        
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.tableView.dequeueReusableCell(withReuseIdentifier: CardDeckCollectionViewCell.identifier(), for: indexPath) as! CardDeckCollectionViewCell
        
        cell.titleLabel.text = ""
        cell.backgroundColor = UIColor.white
        
        if indexPath.row < deckViewEntity.deckEntitys.count {
            let deckEntity = deckViewEntity.deckEntitys[indexPath.row]
            let cardEntity = getCardEntity(id: deckEntity.id)
            
            if self.cardDeckType() == 1 {
                cell.titleLabel.text = cardEntity.titleChinese
            } else {
                cell.titleLabel.text = cardEntity.titleChinese + " x " + deckEntity.number.description
            }
            setImage(card: cell.cardImageView, id: cardEntity.id)
        }
        
        
        return cell
    }
}
