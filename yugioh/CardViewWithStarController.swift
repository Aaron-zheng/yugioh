//
//  CardViewWithStarController.swift
//  yugioh
//
//  Created by Aaron on 30/1/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class CardViewWithStarController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var cardEntitys: Array<CardEntity>!
    let cardService = CardService()
    
    override func viewDidLoad() {
        self.setupTableView()
        self.setupObserver()
        
    }
    
    private func setupObserver() {
        nc.addObserver(self, selector: #selector(CardViewController.clickStarButtonHandler(notification:)), name: Notification.Name("clickStarButton"), object: nil)
    }
    
    private func setupTableView() {
        
        let controller = self.tabBarController as! ViewController
        self.cardEntitys = controller.cardEntitys
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CardTableViewCell.NibObject(), forCellReuseIdentifier: CardTableViewCell.identifier())
        self.tableView.backgroundColor = greyColor
        self.tableView.separatorStyle = .none
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func clickStarButtonHandler(notification: Notification) {
        let cardEntity = notification.userInfo!["data"] as! CardEntity
        if cardEntity.isSelected == true {
            cardService.save(cardEntity: cardEntity)
        } else {
            cardService.delete(cardEntity: cardEntity)
        }
        self.tableView.reloadData()
    }
    
    func isTabItemStar() -> Bool {
        return tabBarItem.title == tabBarItemStar
    }
    
    
    
    @objc(tableView:didSelectRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let controller = CardDetailViewController()
        controller.cardEntity = cardEntitys[indexPath.row]
        controller.frameWidth = self.tableView.frame.width
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


extension CardViewWithStarController: UITableViewDataSource {
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cardEntitys = cardService.list()
        return cardEntitys.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identifier(), for: indexPath) as! CardTableViewCell
        let cardEntity = cardEntitys[indexPath.row]
        cardEntity.isSelected = false
        let list = cardService.list()
        for i in 0 ..< list.count {
            if cardEntity.id == list[i].id {
                cardEntity.isSelected = true
                break
            }
        }
        
        
        cell.prepare(cardEntity: cardEntity, tableView: tableView, indexPath: indexPath)
        return cell
    }
    
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var ifLastRowWillAddGap: CGFloat = 0
        if indexPath.row == cardEntitys.count - 1 {
            ifLastRowWillAddGap = 8
        }
        
        return (self.view.frame.width - materialGap * 2) / 3 / 160 * 230 + materialGap + ifLastRowWillAddGap
    }
    
    @objc(tableView:didEndDisplayingCell:forRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! CardTableViewCell).card.kf.cancelDownloadTask()
    }
    
    @objc(tableView:willDisplayCell:forRowAtIndexPath:)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = (cell as! CardTableViewCell)
        
        setImage(card: cell.card, url: cardEntitys[indexPath.row].url)
        
    }
 
}


extension CardViewWithStarController: UITableViewDelegate {
    
}
