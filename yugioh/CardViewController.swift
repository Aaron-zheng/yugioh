//
//  CardController.swift
//  yugioh
//
//  Created by Aaron on 24/9/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class CardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    
    var originalCardEntitys: Array<CardEntity>! = []
    var cardEntitys: Array<CardEntity>! = []
    let cardService = CardService()
    
    override func viewDidLoad() {
        self.setupTableView()
        self.setupObserver()
        self.setupSearchButton()
        
        CardVariables.packTableViewControllerDelegate = self
    }
    
    private var lastContentOffset: CGFloat! = 0
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if cardEntitys.count <= 0 {
            return
        }
        
        if scrollView.contentOffset.y <= 0 {
            searchButton.isHidden = false
        } else {
            if lastContentOffset < scrollView.contentOffset.y {
                searchButton.isHidden = true
            } else {
                searchButton.isHidden = false
            }
        }
        
        lastContentOffset = scrollView.contentOffset.y
    }
    
    private func setupSearchButton() {
        
        let img = UIImage(named: "ic_search_white")?.withRenderingMode(.alwaysTemplate)
        searchButton.setImage(img, for: .normal)
        searchButton.tintColor = UIColor.white
        searchButton.layer.cornerRadius = 25
        searchButton.backgroundColor = redColor
        
        searchButton.addTarget(self, action: #selector(CardViewController.clickSearchButton), for: .touchUpInside)
    }
    
    func clickSearchButton() {
        let controller = CardSearchViewController()
        controller.cardEntitys = cardEntitys
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: false)

    }
    
    private func setupObserver() {
        nc.addObserver(self, selector: #selector(CardViewController.clickStarButtonHandler(notification:)), name: Notification.Name("clickStarButton"), object: nil)
    }
    
    private func setupTableView() {
        
        let controller = self.tabBarController as! ViewController
        self.originalCardEntitys = controller.cardEntitys
        self.cardEntitys = self.originalCardEntitys
        
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
    
    
    @objc(tableView:didSelectRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let controller = CardDetailViewController()
        controller.cardEntity = cardEntitys[indexPath.row]
        controller.frameWidth = self.tableView.frame.width
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func filter(selectedPack: String?) {
        self.cardEntitys = []
        if selectedPack == nil || selectedPack == "所有卡包" || selectedPack == "" {
            self.cardEntitys = self.originalCardEntitys
        } else {
            for cardEntity in originalCardEntitys {
                if cardEntity.pack.contains(selectedPack!) {
                    self.cardEntitys.append(cardEntity)
                }
            }
        }
    }
}


extension CardViewController: UITableViewDataSource {
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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


struct CardVariables {
    static var packTableViewControllerDelegate: PackTableViewControllerDelegate? = nil
}

extension CardViewController: UITableViewDelegate {
    
}

extension CardViewController: PackTableViewControllerDelegate {
    
    
    func didFinish(selectedPack: String?) {
        filter(selectedPack: selectedPack)
        self.tableView.reloadData()
    }
}
