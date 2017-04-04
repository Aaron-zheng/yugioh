//
//  ViewController.swift
//  yugioh
//
//  Created by Aaron on 24/9/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import UIKit


class ViewController: UITabBarController {
    
    @IBOutlet var packButton: UIBarButtonItem!
    
    fileprivate var currentNodeName: String!
    fileprivate var cardEntity: CardEntity!
    var cardEntitys: Array<CardEntity> = []
    let cardService = CardService()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        if item.title!.description != tabBarItemCard {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = packButton
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupData()
        self.setupTabBarStyle()
        self.setupObserver()
    }
    
    
    private func setupTabBarStyle() {
        self.tabBar.tintColor = greenColor
        self.tabBar.barTintColor = greyColor
    }
    
    private func setupData() {
        let xmlParser = XMLParser(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "datasource", ofType: "xml")!))
        xmlParser?.delegate = self
        xmlParser?.parse()
        
    }

    
    
    private func setupObserver() {
        nc.addObserver(self, selector: #selector(ViewController.clickStarButtonHandler(notification:)), name: Notification.Name("clickStarButton"), object: nil)
    }
    
    func clickStarButtonHandler(notification: Notification) {
        let cardEntity = notification.userInfo!["data"] as! CardEntity
        let tableView = notification.userInfo!["tableView"] as! UITableView
        if cardEntity.isSelected == true {
            cardService.save(cardEntity: cardEntity)
        } else {
            cardService.delete(cardEntity: cardEntity)
        }
        tableView.reloadData()
    }
    
}


extension ViewController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentNodeName = elementName
        if currentNodeName == "element" {
            cardEntity = CardEntity()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "element" {
            cardEntitys.append(cardEntity!)
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let str = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if str.isEmpty {
            return
        }
        
        switch currentNodeName {
        case "id":
            cardEntity.id = str
            cardEntity.url = qiniuUrlPrefix + str + qiniuUrlSuffix
        case "cname":
            cardEntity.title = cardEntity.title + str
        case "type":
            cardEntity.type = str
        case "effect":
            cardEntity.effect = cardEntity.effect + str
        case "starlevel":
            cardEntity.star = cardEntity.star + str
        case "attack":
            cardEntity.attack = cardEntity.attack + str
        case "defense":
            cardEntity.defense = cardEntity.defense + str
        case "pack":
            cardEntity.pack = cardEntity.pack + str
        default:
            break
        }

    }
    
}
