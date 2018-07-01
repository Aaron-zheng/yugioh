//
//  CalculateViewController.swift
//  游戏王卡牌
//
//  Created by Aaron on 16/5/2018.
//  Copyright © 2018 sightcorner. All rights reserved.
//

import Foundation
import UIKit

class CalculateViewController: UIViewController {
    
    let datas = ["", "", "", "清除", "",
                 "-", "1", "2", "3", "-",
                 "+", "4", "5", "6", "+",
                 "减半", "7","8","9", "减半",
                 "变成", "0", "00", "000", "变成"]
    
    var calculateButton: DataButton!
 
    @IBOutlet weak var scoreLableOne: UILabel!
    @IBOutlet weak var scoreLableTwo: UILabel!
    
    override func viewDidLoad() {
        setup()
    }
    
    
    func setup() {
        self.view.backgroundColor = greyColor
        //添加计分版按钮
        addButtons(datas: datas, dataWidth: 56, dataHeight: 56, dataDefaultHeight: 200)
    }
    
    
    
    private func addButtons(datas: [String],
                            dataWidth: Int, dataHeight: Int, dataDefaultHeight: Int
        ) {
        let rootWidth = self.view.frame.width
        let columnGap: Int = 8
        let rowGap: Int = 4
        
        let num = 5
        let gap = (Int(rootWidth) - (dataWidth + columnGap) * num - columnGap) / 2 + columnGap
        
        var row = 0
        var column = 0
        
        
        
        for data in datas {
            
            let button: DataButton
            if(row == 0 && column == 2) {
                let f = CGRect(x: gap + 1 * (dataWidth + columnGap), y: dataDefaultHeight + row * (dataHeight + rowGap), width: (dataWidth) * 2 + rowGap, height: dataHeight)
                button = DataButton(frame: f)
                button.setTitleColor(UIColor.black.withAlphaComponent(0.54), for: .normal)
                button.backgroundColor = UIColor.white
                button.layer.cornerRadius = 4
                self.calculateButton = button
                
            } else if(data == "") {
                column = column + 1
                if column == num {
                    column = 0
                    row = row + 1
                }
                continue
            } else if (column % 5 == 0 || column % 5 == 4) {
                let f = CGRect(x: gap + column * (dataWidth + columnGap), y: dataDefaultHeight + row * (dataHeight + rowGap), width: dataWidth, height: dataHeight)
                button = DataButton(frame: f)
                button.setTitleColor(UIColor.white.withAlphaComponent(0.87), for: .normal)
                button.backgroundColor = redColor
                button.layer.cornerRadius = 8
            } else {
                let f = CGRect(x: gap + column * (dataWidth + columnGap), y: dataDefaultHeight + row * (dataHeight + rowGap), width: dataWidth, height: dataHeight)
                button = DataButton(frame: f)
                button.setTitleColor(UIColor.black.withAlphaComponent(0.54), for: .normal)
                button.backgroundColor = UIColor.white
                button.layer.cornerRadius = 4
            }
            
            button.setTitle(data, for: .normal)
            button.data = data
            button.index = column
            button.addTarget(self, action: #selector(CalculateViewController.performButton), for: .touchUpInside)
            self.view.addSubview(button)
            
            column = column + 1
            if column == num {
                column = 0
                row = row + 1
            }
        }
    }
    
    
    
    @objc private func performButton(sender: DataButton) {
        if sender.data == "" {
            return
        }
        
        if sender.data == "+" {
            if self.calculateButton.currentTitle == "" {
                return
            }
            if sender.index == 0 {
                let point = Int(self.calculateButton.currentTitle!)!
                let score = Int(self.scoreLableOne.text!)!
                self.scoreLableOne.text = (score + point).description
            } else {
                let point = Int(self.calculateButton.currentTitle!)!
                let score = Int(self.scoreLableTwo.text!)!
                self.scoreLableTwo.text = (score + point).description
            }
            return
        }
        
        if sender.data == "-" {
            if self.calculateButton.currentTitle == "" {
                return
            }
            if sender.index == 0 {
                let point = Int(self.calculateButton.currentTitle!)!
                let score = Int(self.scoreLableOne.text!)!
                self.scoreLableOne.text = (score - point).description
            } else {
                let point = Int(self.calculateButton.currentTitle!)!
                let score = Int(self.scoreLableTwo.text!)!
                self.scoreLableTwo.text = (score - point).description
            }
            return
        }
        
        if sender.data == "减半" {
            if sender.index == 0 {
                let score = Int(self.scoreLableOne.text!)! / 2
                self.scoreLableOne.text = score.description
            } else {
                let score = Int(self.scoreLableTwo.text!)! / 2
                self.scoreLableTwo.text = score.description
            }
            return
        }
        
        if sender.data == "变成" {
            if self.calculateButton.currentTitle == "" {
                return
            }
            if sender.index == 0 {
                self.scoreLableOne.text = self.calculateButton.currentTitle!
            } else {
                self.scoreLableTwo.text = self.calculateButton.currentTitle!
            }
            return
        }
        
        if sender.data == "清除" {
           self.calculateButton.setTitle("", for: .normal)
        }
        
        if isStringAnInt(string: sender.data) {
            let title = self.calculateButton.currentTitle! + sender.data
            self.calculateButton.setTitle(title, for: .normal)
            return
        }
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
}
