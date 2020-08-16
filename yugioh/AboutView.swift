//
//  AboutView.swift
//  yugioh
//
//  Created by Aaron on 16/8/2020.
//  Copyright © 2020 sightcorner. All rights reserved.
//

import Foundation
import UIKit

class AboutView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("AboutView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.contentView.backgroundColor = greyColor
    }
    
}
