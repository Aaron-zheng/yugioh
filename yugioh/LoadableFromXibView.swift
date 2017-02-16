//
//  LoadableFromXibView.swift
//  yugioh
//
//  Created by Aaron on 16/2/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//


import Foundation
import UIKit

protocol NibDefinable {
    var nibName: String { get }
}

extension NibDefinable {
    var nibName : String {
        return String(describing: type(of: self))
    }
}

class LoadableFromXibView: UIView, NibDefinable {
    
    @IBOutlet weak var view : UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    */
    
    func xibSetup() {
        view = loadViewFromXib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}
