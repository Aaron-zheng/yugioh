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
    
    
    fileprivate var cardEntitys: Array<CardEntity>! = []
    fileprivate var rootController: ViewController!
    fileprivate var deckEntitys: [DeckEntity]! = []
    
    fileprivate let deckService = DeckService()
    
    
    @IBOutlet weak var tableView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        deckEntitys = deckService.list()
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        deckEntitys = deckService.list()
        //
        rootController = self.tabBarController as! ViewController
        //
        self.cardEntitys = rootController.cardEntitys
        //
        self.tableView.backgroundColor = greyColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CardDeckCollectionViewCell.NibObject(), forCellWithReuseIdentifier: CardDeckCollectionViewCell.identifier())
        //
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
        let deckEntity = deckEntitys[indexPath.row]
        let cardEntity = rootController.getCardEntity(id: deckEntity.id)
        let controller = CardDetailViewController()
        controller.cardEntity = cardEntity
        controller.hidesBottomBarWhenPushed = true
        controller.proxy = self.tableView
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}

extension CardDeckViewController: UICollectionViewDataSource {
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deckEntitys.count
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.tableView.dequeueReusableCell(withReuseIdentifier: CardDeckCollectionViewCell.identifier(), for: indexPath) as! CardDeckCollectionViewCell
        
        cell.titleLabel.text = ""
        cell.backgroundColor = UIColor.white
        
        if indexPath.row < deckEntitys.count {
            let deckEntity = deckEntitys[indexPath.row]
            let cardEntity = rootController.getCardEntity(id: deckEntity.id)
            
            cell.titleLabel.text = cardEntity.titleChinese + " x " + deckEntity.number.description
            setImage(card: cell.cardImageView, url: cardEntity.url)
        }
        
        
        return cell
    }
}
