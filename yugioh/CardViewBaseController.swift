//
//  CardViewBaseController.swift
//  yugioh
//
//  Created by Aaron on 2/4/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class CardViewBaseController: UIViewController {


    var tableView: UITableView!
    var cardEntitys: Array<CardEntity>! = []
    
    fileprivate let cardService = CardService()
    
    var afterDeselect: (() -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
    }
    
    
    func setupTableView() {
        self.cardEntitys = globalCardEntitys
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CardTableViewCell.NibObject(), forCellReuseIdentifier: CardTableViewCell.identifier())
        self.tableView.backgroundColor = greyColor
        self.tableView.separatorStyle = .none
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    @objc(tableView:didSelectRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let controller = CardDetailViewController()
        controller.cardEntity = cardEntitys[indexPath.row]
        controller.hidesBottomBarWhenPushed = true
        controller.proxy = self.tableView
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    
}


extension CardViewBaseController: UITableViewDataSource {
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardEntitys.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identifier(), for: indexPath) as! CardTableViewCell
        let cardEntity = cardEntitys[indexPath.row]
        if cardService.isExist(id: cardEntity.id) {
            cardEntity.isSelected = true
        } else {
            cardEntity.isSelected = false
        }
        if let f = afterDeselect {
            cell.afterDeselect = f
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
        setImage(card: cell.card, id: cardEntitys[indexPath.row].id)
        
    }
    
    
}


extension CardViewBaseController: UITableViewDelegate {
    
}
