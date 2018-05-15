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
    
    let datas = ["1","2","3","4","5","6","7","8","9","0"]
    
 
    override func viewDidLoad() {
        setup()
    }
    
    
    func setup() {
        self.view.backgroundColor = greyColor
        addButtons(datas: datas, dataWidth: 64, dataHeight: 64, dataDefaultHeight: 120)
    }
    
    
    private func addButtons(datas: [String],
                            dataWidth: Int, dataHeight: Int, dataDefaultHeight: Int
        ) {
        let rootWidth = self.view.frame.width
        let columnGap: Int = 8
        let rowGap: Int = 4
        
        var num = Int(rootWidth) / (dataWidth + columnGap) 
        if num > datas.count {
            num = datas.count
        }
        let gap = (Int(rootWidth) - (dataWidth + columnGap) * num - columnGap) / 2 + columnGap
        
        var row = 0
        var column = 0
        
        
        
        for data in datas {
            let f = CGRect(x: gap + column * (dataWidth + columnGap), y: dataDefaultHeight + row * (dataHeight + rowGap), width: dataWidth, height: dataHeight)
            
            let button = DataButton(frame: f)
            button.layer.cornerRadius = 4
            button.setTitleColor(UIColor.black.withAlphaComponent(0.54), for: .normal)
            button.backgroundColor = UIColor.white
            button.data = data
            button.setTitle(data, for: .normal)
//            button.addTarget(self, action: selector, for: .touchUpInside)
            self.view.addSubview(button)
            
            column = column + 1
            if column == num {
                column = 0
                row = row + 1
            }
        }
    
        
    }
    
}
