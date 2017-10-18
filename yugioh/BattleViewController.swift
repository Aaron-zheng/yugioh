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
//    private var ref: WDGSyncReference!
    
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        
        let img = UIImage(named: "ic_view_carousel_white")?.withRenderingMode(.alwaysTemplate)
        button.setImage(img, for: .normal)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 25
        button.backgroundColor = redColor
        
        
//        let options = WDGOptions.init(syncURL: "https://yugioh.wilddogio.com")
//        WDGApp.configure(with: options)
//        ref = WDGSync.sync().reference()
    }
    
    @IBAction func clickButtonHandler(_ sender: UIButton) {
            
        if original.count <= 0 {
            return
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(original.count)))
        let val: String = original[randomIndex]
        original.remove(at: randomIndex)
        
        
        let imgView = UIImageView(frame: CGRect(x: 64 + (40 - original.count) * 2, y: Int(UIScreen.main.bounds.height - 160), width: 50, height: 72))
        setImage(card: imgView, id: val)
        
        var panGesture  = UIPanGestureRecognizer()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(BattleViewController.draggedView(_:)))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(panGesture)
        self.view.addSubview(imgView)
        imgArray.append(imgView)
        
        /*
        //
        let roomRef = ref.child("room1").child("operator1")
        roomRef.childByAutoId().setValue(["cardId": val.description, "x": imgView.frame.origin.x, "y": imgView.frame.origin.y])
        //
        let oppositeRef = WDGSync.sync().reference(withPath: "room1")
        oppositeRef.observe(.value, with: {snapshot in
            
            let room1 = snapshot.value as! NSDictionary
            let operator1 = room1["operator1"] as! NSDictionary
            for card in operator1 {
                let cardDict = card.value as! NSDictionary
                let x = cardDict["x"] as! Int
                let y = cardDict["y"] as! Int
                let cardId = cardDict["cardId"] as! String
                let imgView = UIImageView(frame: CGRect(x: x, y: y - 100, width: 50, height: 72))
                setImage(card: imgView, )
                self.view.addSubview(imgView)
            }
            
        })
        */
        
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
