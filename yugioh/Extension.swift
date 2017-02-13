//
//  UIViewContrller+Extension.swift
//  yugioh
//
//  Created by Aaron on 24/9/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//


import Foundation
import UIKit


extension NSObject {
    
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }
    
    class func identifier() -> String {
        return String(format: "%@_identifier", self.nameOfClass)
    }
}


extension UIView {
    
    /**
     主要用于获取 Cell 的 Nib 对象，用于 registerNib
     */
    class func NibObject() -> UINib {
        let hasNib: Bool = Bundle.main.path(forResource: self.nameOfClass, ofType: "nib") != nil
        guard hasNib else {
            return UINib()
        }
        return UINib(nibName: self.nameOfClass, bundle:nil)
    }
}




