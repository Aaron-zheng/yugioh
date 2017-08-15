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

class CardViewWithStarController: CardViewBaseController {
    
    
    
    @IBOutlet weak var iTableView: UITableView!
    
    private var cardService = CardService()
    
    
    override func viewDidLoad() {
        self.tableView = iTableView
        self.setupTableView()
        self.afterDeselect = starAfterDeselect
        
        
    }
    
    func starAfterDeselect() {
        self.tableView.reloadData()
    }
    
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ids = cardService.list()
        self.cardEntitys = []
        
        for index in 0..<ids.count {
            cardEntitys.append(getCardEntity(id: ids[index]))
        }
        
        
        
        return self.cardEntitys.count
    }
}
