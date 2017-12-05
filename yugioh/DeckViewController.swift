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
    
    fileprivate var deckService: DeckService = DeckService()
    
    
    fileprivate var deckViewEntitys: [DeckViewEntity] = deckViewEntitysConstant
    
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(DeckTableCell.NibObject(), forCellReuseIdentifier: DeckTableCell.identifier())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}


extension DeckViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let controller = CardDeckViewController()
        let rootController: ViewController = self.tabBarController as! ViewController
        controller.rootController = rootController
        let deckViewEntity = deckViewEntitys[indexPath.row]
        controller.deckViewEntity = deckViewEntity
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
        if deckViewEntity.id == "0" {
            let array: [String: [DeckEntity]] = deckService.list()
            cell.introduction.text = "当前主卡组：" + count(array: array["0"]!) + "   副卡组：" + count(array:array["1"]!) + "   额外卡组：" + count(array:array["2"]!)
        }
        return cell
    }
    
    func count(array: [DeckEntity]) -> String {
        var result = 0
        for each in array {
            result = result + each.number
        }
        return result.description
    }
}
