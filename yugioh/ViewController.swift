//
//  ViewController.swift
//  yugioh
//
//  Created by Aaron on 24/9/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import UIKit
import SQLite


class ViewController: UITabBarController {
    
    @IBOutlet var packButton: UIBarButtonItem!
    
    fileprivate var currentNodeName: String!
    fileprivate var cardEntity: CardEntity!
    var cardEntitys: Array<CardEntity> = []
    let cardService = CardService()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        if item.title!.description != tabBarItemCard {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = packButton
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupData()
        self.setupTabBarStyle()
        
        
    }
    
    
    private func setupTabBarStyle() {
        self.tabBar.tintColor = greenColor
        self.tabBar.barTintColor = greyColor
    }
    
    private func setupData() {
        do {
            let path = Bundle.main.path(forResource: "cards", ofType: "cdb")
            
            let db = try Connection(path!)
            
            for each in try db.prepare("select * from info") {
                cardEntity = CardEntity()
                cardEntity.id = each[0] as! String
                cardEntity.titleChinese = each[1] as! String
                cardEntity.titleJapanese = each[2] as! String
                cardEntity.titleEnglish = each[3] as! String
                cardEntity.type = each[4] as! String
                cardEntity.password = each[5] as! String
                cardEntity.usage = each[6] as! String
                cardEntity.race = each[7] as! String
                cardEntity.property = each[8] as! String
                cardEntity.star = each[9] as! String
                cardEntity.attack = each[10] as! String
                cardEntity.defense = each[11] as! String
                cardEntity.rare = each[12] as! String
                cardEntity.effect = each[13] as! String
                cardEntity.pack = each[14] as! String
                cardEntitys.append(cardEntity)
            }
            
            globalCardEntitys = self.cardEntitys
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
