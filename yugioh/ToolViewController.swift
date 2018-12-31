//
//  ToolViewController.swift
//  yugioh
//
//  Created by Aaron on 31/12/2018.
//  Copyright © 2018 sightcorner. All rights reserved.
//

import Foundation
import UIKit


class ToolViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var calculateView: CalculateView!
    
    @IBOutlet weak var battleView: BattleView!
    
    override func viewDidAppear(_ animated: Bool) {
        display()
    }
    
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        display()
    }
    
    private func display() {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.calculateView.isHidden = false
            self.battleView.isHidden = true
        } else if segmentedControl.selectedSegmentIndex == 1 {
            self.calculateView.isHidden = true
            self.battleView.isHidden = false
            self.battleView.initialCard()
        } else {
            
        }
    }
}
