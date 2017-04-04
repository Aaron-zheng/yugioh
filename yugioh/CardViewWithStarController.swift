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
    
    
    override func viewDidLoad() {
        self.rootController = self.tabBarController as! ViewController
        self.tableView = iTableView
        self.setupTableView()
    }
    
    
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cardEntitys = self.rootController.cardService.list()
        return self.cardEntitys.count
    }
}
