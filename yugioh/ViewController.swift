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
    
    // 搜索按钮
    @IBOutlet var packButton: UIBarButtonItem!
    
    // 翻译按钮
    @IBOutlet var languageButton: UIBarButtonItem!
    
    
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
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        if item.title!.description != tabBarItemCard {
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = packButton
            self.navigationItem.leftBarButtonItem = languageButton
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.conversion()
        self.setupData()
        self.setupTabBarStyle()
        
        self.languageButton = UIBarButtonItem.init(
            image: UIImage(named:"language-language_symbol")!,
            style: .done,
            target: self,
            action: #selector(ViewController.clickLanguageButton(_:))
        )
        self.navigationItem.leftBarButtonItem = self.languageButton
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
    }
    @IBAction func clickLanguageButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Language", message: nil, preferredStyle: .actionSheet)
        let chinese = UIAlertAction(title: "中文", style: .default, handler: {(action) -> Void in
            language = "cn"
            nc.post(name: Notification.Name.NOTIFICATION_NAME_LANGUAGE_CHANGE, object: nil)
        })
        let english = UIAlertAction(title: "English", style: .default, handler: {(action) -> Void in
            language = "en"
            nc.post(name: Notification.Name.NOTIFICATION_NAME_LANGUAGE_CHANGE, object: nil)
        })
        let fr = UIAlertAction(title: "Français", style: .default, handler: {(action) -> Void in
            language = "fr"
            nc.post(name: Notification.Name.NOTIFICATION_NAME_LANGUAGE_CHANGE, object: nil)
        })
        let it = UIAlertAction(title: "Italian", style: .default, handler: {(action) -> Void in
            language = "it"
            nc.post(name: Notification.Name.NOTIFICATION_NAME_LANGUAGE_CHANGE, object: nil)
        })
        let pt = UIAlertAction(title: "Português", style: .default, handler: {(action) -> Void in
            language = "pt"
            nc.post(name: Notification.Name.NOTIFICATION_NAME_LANGUAGE_CHANGE, object: nil)
        })
        let cancelButton = UIAlertAction(title: "cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        alertController.addAction(chinese)
        alertController.addAction(english)
//        alertController.addAction(fr)
//        alertController.addAction(it)
//        alertController.addAction(pt)
        alertController.addAction(cancelButton)
        
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    
}


