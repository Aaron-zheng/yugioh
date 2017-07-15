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
    
    var count: Int = 0
    var cardEntitys: Array<CardEntity>! = []
    var rootController: ViewController!
    
    
    @IBOutlet weak var tableView: UICollectionView!
    
    
    override func viewDidLoad() {
        //
        rootController = self.tabBarController as! ViewController
        //
        self.cardEntitys = rootController.cardEntitys
        //
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CardDeckCollectionViewCell.NibObject(), forCellWithReuseIdentifier: CardDeckCollectionViewCell.identifier())
        //
    }
}

extension CardDeckViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = rootController.view.frame.size
        let w = (size.width - 16) / 2
        let h = (size.height - 50 - 40 - 40 - 16) / 20
        return CGSize.init(width: w, height: h)
        
    }
}

extension CardDeckViewController: UICollectionViewDelegate {
    
}

extension CardDeckViewController: UICollectionViewDataSource {
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withReuseIdentifier: CardDeckCollectionViewCell.identifier(), for: indexPath) as! CardDeckCollectionViewCell
        count = count + 1
        
        cell.titleLabel.text = cardEntitys[indexPath.row].titleChinese + " x " + count.description
        setImage(card: cell.cardImageView, url: cardEntitys[indexPath.row].url)
        
        
        return cell
    }
}
