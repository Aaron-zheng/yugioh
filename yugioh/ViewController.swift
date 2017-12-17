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
    
    
    @IBAction func signupHandle(_ sender: Any) {
        
        if LCUser.current != nil {
            let aboutController = AboutViewController()
            self.navigationController?.pushViewController(aboutController, animated: true)
        } else {
            let loginController = LFLoginController()
            loginController.delegate = self
            self.navigationController?.pushViewController(loginController, animated: true)
        }
        
        
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


extension ViewController: LFLoginControllerDelegate {
    func forgotPasswordTapped(email: String) {
        
    }
    
    
    func loginDidFinish(email: String, password: String, type: LFLoginController.SendType) {
        if type == LFLoginController.SendType.Login {//登陆
            login(username: email, password: password)
        } else {//注册
            signup(email: email, password: password)
        }
    }
    
    private func login(username: String, password: String) {
        let result = LCUser.logIn(username: username, password: password)
        if result.isSuccess {
            self.navigationController?.popViewController(animated: true)
            print("登陆成功")
        } else {
            print("登陆失败")
        }
    }
    
    private func signup(email: String, password: String) {
        let signupUser = LCUser()
        signupUser.username = LCString(email)
        signupUser.email = LCString(email)
        signupUser.password = LCString(password)
        let result = signupUser.signUp()
        if result.isSuccess {
            print("注册成功")
            self.login(username: email, password: password)
        } else {
            print("注册失败")
        }
    }
    
}
