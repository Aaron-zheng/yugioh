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
    
    fileprivate let deckService = DeckService()
    
    
    fileprivate var deckViewEntitys: [DeckViewEntity] = [
        DeckViewEntity(id: "2003",
                       title: "2003年第1届冠军",
                       introduction: "使用时间：2003年8月10日 使用地点：美国纽约 使用者：Ng Yu Leung 所属国家地区：中国香港 卡组类型：【手札破坏】",
                       deckEntitys: [
                        DeckEntity(id: "91", number: 1),
                        DeckEntity(id: "498", number: 3),
                        DeckEntity(id: "366", number: 1),
                        DeckEntity(id: "657", number: 2),
                        DeckEntity(id: "79", number: 3),
                        DeckEntity(id: "454", number: 1),
                        DeckEntity(id: "416", number: 1),
                        DeckEntity(id: "590", number: 1),
                        DeckEntity(id: "260", number: 1),
                        DeckEntity(id: "1158", number: 1),
                        DeckEntity(id: "601", number: 1),
                        DeckEntity(id: "220", number: 1),
                        DeckEntity(id: "504", number: 1),
                        DeckEntity(id: "663", number: 1),
                        DeckEntity(id: "172", number: 1),
                        DeckEntity(id: "171", number: 1),
                        DeckEntity(id: "124", number: 1),
                        DeckEntity(id: "1149", number: 1),
                        DeckEntity(id: "478", number: 1),
                        DeckEntity(id: "37", number: 3),
                        DeckEntity(id: "272", number: 1),
                        DeckEntity(id: "26", number: 1),
                        DeckEntity(id: "219", number: 1),
                        DeckEntity(id: "127", number: 1),
                        DeckEntity(id: "28", number: 1),
                        DeckEntity(id: "35", number: 1),
                        DeckEntity(id: "29", number: 1),
                        DeckEntity(id: "122", number: 1),
                        DeckEntity(id: "474", number: 1),
                        DeckEntity(id: "1171", number: 1),
                        DeckEntity(id: "101", number: 1),
                        DeckEntity(id: "631", number: 3)
            ]),
        DeckViewEntity(id: "2004",
                       title: "2004年第2届冠军",
                       introduction: "使用时间：2004年7月25日 使用地点：美国洛杉矶 使用者：Togawa Masatoshi 所属国家地区：日本卡 组类型：【混沌Control】",
                       deckEntitys: [
                        DeckEntity(id: "1004", number: 1),
                        DeckEntity(id: "973", number: 1),
                        DeckEntity(id: "91", number: 1),
                        DeckEntity(id: "366", number: 2),
                        DeckEntity(id: "806", number: 1),
                        DeckEntity(id: "811", number: 1),
                        DeckEntity(id: "868", number: 3),
                        DeckEntity(id: "73", number: 1),
                        DeckEntity(id: "454", number: 1),
                        DeckEntity(id: "416", number: 1),
                        DeckEntity(id: "260", number: 1),
                        DeckEntity(id: "808", number: 1),
                        DeckEntity(id: "1158", number: 1),
                        DeckEntity(id: "220", number: 1),
                        DeckEntity(id: "504", number: 1),
                        DeckEntity(id: "663", number: 1),
                        DeckEntity(id: "171", number: 1),
                        DeckEntity(id: "1043", number: 1),
                        DeckEntity(id: "124", number: 1),
                        DeckEntity(id: "478", number: 1),
                        DeckEntity(id: "37", number: 3),
                        DeckEntity(id: "26", number: 1),
                        DeckEntity(id: "615", number: 1),
                        DeckEntity(id: "219", number: 1),
                        DeckEntity(id: "127", number: 1),
                        DeckEntity(id: "28", number: 1),
                        DeckEntity(id: "35", number: 1),
                        DeckEntity(id: "1226", number: 2),
                        DeckEntity(id: "474", number: 1),
                        DeckEntity(id: "335", number: 2),
                        DeckEntity(id: "1171", number: 1),
                        DeckEntity(id: "101", number: 1)
            ])
    ]
    
    
    override func viewDidLoad() {
        deckViewEntitys.append(DeckViewEntity(id: "100", title: "我的卡组", introduction: "我的卡组", deckEntitys: deckService.list()))
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
