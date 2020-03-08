//
//  ViewController.swift
//  yugioh
//
//  Created by Aaron on 24/9/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import UIKit
import SQLite
import LeanCloud

class ViewController: UITabBarController {
    
    @IBOutlet var packButton: UIBarButtonItem!
    
    fileprivate var currentNodeName: String!
    var cardEntitys: Array<CardEntity> = []
    let cardService = CardService()
    let deckService = DeckService()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    @IBAction func signupHandle(_ sender: Any) {
        
        let aboutController = AboutViewController()
        self.navigationController?.pushViewController(aboutController, animated: true)
        
        
        
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
        self.setNeedsStatusBarAppearanceUpdate()
        self.conversion()
        self.setupData()
        self.setupTabBarStyle()
    }
    
    private func conversion() {
        self.deckService.conversion()
    }
    
    
    private func setupTabBarStyle() {
        self.tabBar.tintColor = greenColor
        self.tabBar.barTintColor = greyColor
    }
    
    private func setupData() {
        cardEntitys = getCardEntity()
        globalCardEntitys = self.cardEntitys
    }
    
}


