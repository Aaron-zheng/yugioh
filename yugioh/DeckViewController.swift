//
//  DeckViewController.swift
//  yugioh
//
//  Created by Aaron on 6/8/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation

import UIKit

class DeckViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    fileprivate var deckViewEntitys: [DeckViewEntity] = deckViewEntitysConstant
    
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(DeckTableCell.NibObject(), forCellReuseIdentifier: DeckTableCell.identifier())
        
    }
}


extension DeckViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let controller = CardDeckViewController()
        let rootController: ViewController = self.tabBarController as! ViewController
        controller.rootController = rootController
        controller.deckViewEntity = deckViewEntitys[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

extension DeckViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckViewEntitys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: DeckTableCell.identifier(), for: indexPath) as! DeckTableCell
        let deckViewEntity = deckViewEntitys[indexPath.row]
        cell.title.text = deckViewEntity.title
        cell.introduction.text = deckViewEntity.introduction
        return cell
    }
}
