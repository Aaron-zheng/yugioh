//
//  BattleView.swift
//  yugioh
//
//  Created by Aaron on 31/12/2018.
//  Copyright © 2018 sightcorner. All rights reserved.
//

import Foundation
import UIKit

class BattleView: UIView {
    
    private var deckService = DeckService()
    private var result: [DeckEntity] = []
    private var original: [String] = []
    private var imgArray: [UIImageView] = []
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("BattleView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let img = UIImage(named: "ic_view_carousel_white")?.withRenderingMode(.alwaysTemplate)
        button.setImage(img, for: .normal)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 25
        button.backgroundColor = redColor
        
        self.contentView.backgroundColor = greyColor
    }
    
    func initialCard() {
        for each in imgArray {
            each.removeFromSuperview()
        }
        
        original = []
        imgArray = []
        result = deckService.list()["0"]!
        for each in result {
            for _ in 0 ..< each.number {
                original.append(each.id)
            }
        }
    }
    
    @IBAction func clickButtonHandler(_ sender: UIButton) {
        
        if original.count <= 0 {
            return
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(original.count)))
        let val: String = original[randomIndex]
        original.remove(at: randomIndex)
        
        
        let imgView = UIImageView(frame: CGRect(x: 64 + (40 - original.count) * 4, y: Int(self.frame.height - 160), width: 50, height: 72))
//        let imgView = UIImageView(frame: CGRect(x: 150, y: 40, width: 50, height: 72))
        
        setImage(card: imgView, id: val)
        
        var panGesture  = UIPanGestureRecognizer()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(BattleView.draggedView(_:)))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(panGesture)
        self.addSubview(imgView)
        imgArray.append(imgView)
        
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        let viewDrag = sender.view!
        self.bringSubview(toFront: viewDrag)
        let translation = sender.translation(in: self)
        viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self)
    }
    
    
}
