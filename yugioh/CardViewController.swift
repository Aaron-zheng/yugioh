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

class CardViewController: CardViewBaseController {
    
    @IBOutlet weak var iTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    private var originalCardEntitys: Array<CardEntity>! = []
    
    override func viewDidLoad() {
        self.rootController = self.tabBarController as! ViewController
        self.tableView = iTableView
        self.setupTableView()
        self.setupSearchButton()
        self.originalCardEntitys = self.cardEntitys
        
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
    
    func setupSearchButton() {
        
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
        controller.rootFrame = self.view.frame.size
        self.navigationController?.pushViewController(controller, animated: false)
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






extension CardViewController: PackTableViewControllerDelegate {
    
    
    func didFinish(selectedPack: String?) {
        filter(selectedPack: selectedPack)
        self.tableView.reloadData()
    }
}
