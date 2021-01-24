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
    let deckService = DeckService()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    @IBAction func signupHandle(_ sender: Any) {
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
    
    @IBAction func languageAction(_ sender: Any) {
        let alertController = UIAlertController(title: "语言选择", message: nil, preferredStyle: .actionSheet)
        let chinese = UIAlertAction(title: "中文", style: .default, handler: {(action) -> Void in
            language = "cn"
            self.setupData()
            print("tapped cn")
        })
        let english = UIAlertAction(title: "英文", style: .default, handler: {(action) -> Void in
            language = "en"
            self.setupData()
            print("tapped en")
        })
        let cancelButton = UIAlertAction(title: "取消", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        alertController.addAction(chinese)
        alertController.addAction(english)
        alertController.addAction(cancelButton)
        
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
}


