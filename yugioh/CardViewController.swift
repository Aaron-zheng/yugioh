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
    
    private var originalCardEntitys: Array<CardEntity>! = []
    
    override func viewDidLoad() {
        self.tableView = iTableView
        self.setupTableView()
        self.originalCardEntitys = self.cardEntitys
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 原先用于记录，滚动的y坐标
    }
    

    @objc func clickSearchButton() {
//        let controller = CardSearchViewController()
//        controller.cardEntitys = cardEntitys
//        controller.hidesBottomBarWhenPushed = true
//        controller.rootFrame = self.view.frame.size
//
//        self.navigationController?.pushViewController(controller, animated: false)
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
