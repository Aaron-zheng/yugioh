//
//  CardService.swift
//  yugioh
//
//  Created by Aaron on 26/10/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation

import UIKit
import CoreData



class CardService {
    
    
    private let appDelegate: AppDelegate!
    private let managedContex: NSManagedObjectContext!
    private let entity: NSEntityDescription
    private let entityName: String = "CardPO"
    private let fetchRequest: NSFetchRequest<NSManagedObject>!
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContex = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContex)!
        fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: false)]
    }
    
    
    func list() -> [CardEntity] {
        var result = [CardEntity]()
        do {
            let r = try managedContex.fetch(fetchRequest)
            
            
            for i in 0 ..< r.count {
                let cardEntity = CardEntity()
                cardEntity.attack = r[i].value(forKey: "attack") as? String
                cardEntity.defense = r[i].value(forKey: "defense") as? String
                cardEntity.effect = r[i].value(forKey: "effect") as? String
                cardEntity.id = r[i].value(forKey: "id") as? String
                cardEntity.star = r[i].value(forKey: "star") as? String
                cardEntity.title = r[i].value(forKey: "title") as? String
                cardEntity.type = r[i].value(forKey: "type") as? String
                cardEntity.url = r[i].value(forKey: "url") as? String
                cardEntity.pack = r[i].value(forKey: "pack") as? String
                result.append(cardEntity)
            }
        } catch {
            print("error: list")
        }
        
        return result
        
    }
    
    
    
    func delete(cardEntity: CardEntity) {
        do {
            let result = try managedContex.fetch(fetchRequest)
            for i in 0 ..< result.count {
                if cardEntity.id == result[i].value(forKey: "id") as! String {
                    managedContex.delete(result[i])
                }
            }
            
            try managedContex.save()
            
        } catch {
            print("error: delete")
        }
    }
    
    private func isExist(cardEntity: CardEntity) -> Bool {
        var flag = false
        do {
            let result = try managedContex.fetch(fetchRequest)
            for i in 0 ..< result.count {
                if cardEntity.id == result[i].value(forKey: "id") as! String {
                    flag = true
                }
            }
            
        } catch {
            print("error: isExist")
        }
        
        return flag
        
    }
    
    
    func save(cardEntity: CardEntity) {
        
        if isExist(cardEntity: cardEntity) == true {
            return
        }
        
        let card = CardPO(entity: entity, insertInto: managedContex)
        card.attack = cardEntity.attack
        card.defense = cardEntity.defense
        card.effect = cardEntity.effect
        card.id = cardEntity.id
        card.star = cardEntity.star
        card.title = cardEntity.title
        card.type = cardEntity.type
        card.url = cardEntity.url
        card.pack = cardEntity.pack
        card.createAt = Date()
        
        do {
            try managedContex.save()
        } catch {
            print("error: save")
        }
    }
    
    
}
