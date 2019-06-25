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
//        if LCUser.current != nil {
//            let number = LCUser.current?.value(forKey: "number") as! LCNumber
//            self.userLabel.text = "用户状态：No." + Int(number.value).description + " 注册会员"
//        } else {
//            self.userLabel.text = "用户状态：未登陆"
//        }
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
        
        
    }
}
