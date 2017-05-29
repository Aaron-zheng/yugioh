//
//  DataButton.swift
//  yugioh
//
//  Created by Aaron on 28/5/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation
import UIKit


class DataButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var data: String = ""
    
}
