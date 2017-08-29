//
//  BattleViewController.swift
//  yugioh
//
//  Created by Aaron on 27/8/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation
import UIKit



class BattleViewController: UIViewController {
    
    private var deckService = DeckService()
    private var result: [DeckEntity] = []
    private var original: [String] = []
    private var imgArray: [UIImageView] = []
    
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func clickButtonHandler(_ sender: UIButton) {
        while(true) {
            
            if original.count <= 0 {
                break
            }
            
            let randomIndex = Int(arc4random_uniform(UInt32(original.count)))
            let val: String = original[randomIndex]
            original.remove(at: randomIndex)
            
            
            let imgView = UIImageView(frame: CGRect(x: 64 + (40 - original.count) * 2, y: Int(UIScreen.main.bounds.height - 160), width: 50, height: 72))
            setImage(card: imgView, url: getCardEntity(id: val).url)
            
            var panGesture  = UIPanGestureRecognizer()
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(BattleViewController.draggedView(_:)))
            imgView.isUserInteractionEnabled = true
            imgView.addGestureRecognizer(panGesture)
            self.view.addSubview(imgView)
            imgArray.append(imgView)
            break
        }
        
        
    }
    
    func draggedView(_ sender:UIPanGestureRecognizer){
        let viewDrag = sender.view!
        self.view.bringSubview(toFront: viewDrag)
        let translation = sender.translation(in: self.view)
        viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        for each in imgArray {
            each.removeFromSuperview()
        }
        
        original = []
        imgArray = []
        result = deckService.list()
        for each in result {
            for _ in 0 ..< each.number {
                original.append(each.id)
            }
        }
        
    }
}