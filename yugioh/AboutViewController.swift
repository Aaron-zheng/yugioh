//
//  AboutViewController.swift
//  游戏王卡牌
//
//  Created by Aaron on 18/12/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation
import UIKit
import LeanCloud

class AboutViewController: UIViewController {
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var userLabel: UIVerticalAlignLabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        if LCUser.current != nil {
            let number = LCUser.current?.value(forKey: "number") as! LCNumber
            self.userLabel.text = "用户状态：No." + Int(number.value).description + " 注册会员"
        } else {
            self.userLabel.text = "用户状态：未登陆"
        }
    }
    
    override func viewDidLoad() {
        self.setupSignupButton()
        
        
        
    }
    
    func setupSignupButton() {
        
        let img = UIImage(named: "ic_face_white")?.withRenderingMode(.alwaysTemplate)
        signupButton.setImage(img, for: .normal)
        signupButton.tintColor = UIColor.white
        signupButton.layer.cornerRadius = 25
        signupButton.backgroundColor = redColor
        
        signupButton.addTarget(self, action: #selector(AboutViewController.clickSignupButton), for: .touchUpInside)
    }
    
    
    @objc func clickSignupButton() {
        
        if LCUser.current != nil {
            print("已经登陆")
        } else {
            let loginController = LFLoginController()
            loginController.delegate = self
            self.navigationController?.pushViewController(loginController, animated: true)
        }
    }
}


extension AboutViewController: LFLoginControllerDelegate {
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
