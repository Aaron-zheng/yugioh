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
            for each in try getDB().prepare("select id, titleChinese, titleJapanese, titleEnglish, type, password, usage, race, property, star, attack, defense, rare, effect, pack, scale, adjust from info") {
                cardEntitys.append(buildCardEntity(element: each))
            }
            
            globalCardEntitys = self.cardEntitys
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}
