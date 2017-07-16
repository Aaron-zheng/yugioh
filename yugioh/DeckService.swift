//
//  DeckService.swift
//  yugioh
//
//  Created by Aaron on 15/7/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation

import UIKit
import CoreData



class DeckService {
    
    
    private let appDelegate: AppDelegate!
    private let managedContex: NSManagedObjectContext!
    private let entity: NSEntityDescription
    private let entityName: String = "DeckPO"
    private let fetchRequest: NSFetchRequest<NSManagedObject>!
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContex = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContex)!
        fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
    }
    
    
    func list() -> [DeckEntity] {
        var result = [DeckEntity]()
        do {
            let r = try managedContex.fetch(fetchRequest)
            
            
            for i in 0 ..< r.count {
                let d = DeckEntity()
                d.id = r[i].value(forKey: "id") as! String
                d.number = Int(r[i].value(forKey: "number") as! NSNumber)
                result.append(d)
            }
        } catch {
            print("error: list")
        }
        
        return result
        
    }
    
    func total() -> Int {
        let list: [DeckEntity] = self.list()
        var total = 0
        for each in list {
            total = total + each.number
        }
        return total
    }
    
    
    func isExist(id: String) -> DeckPO? {
        
        do {
            let result = try managedContex.fetch(fetchRequest)
            for i in 0 ..< result.count {
                if id == (result[i].value(forKey: "id") as! String) {
                    return (result[i] as! DeckPO)
                }
            }
        } catch {
            print("error: isExist")
        }
        
        return nil
        
    }
    
    
    func save(id: String) {
        if total() >= 40 {
            return
        }
        
        if let existedDeck = isExist(id: id) {
            if existedDeck.number.intValue >= 3  {
                return
            }
            existedDeck.number = (existedDeck.number.intValue + 1) as NSNumber
        } else {
            let deck = DeckPO(entity: entity, insertInto: managedContex)
            deck.id = id
            deck.number = 1
        }
        
        
        do {
            try managedContex.save()
        } catch {
            print("error: save")
        }
    }
    
    
    func delete(id: String) {
        if let existedDeck = isExist(id: id) {
            
            if existedDeck.number.intValue <= 1 {
                managedContex.delete(existedDeck)
            } else {
                existedDeck.number = (existedDeck.number.intValue - 1) as NSNumber
            }
            
        }
        
        do {
            try managedContex.save()
        } catch {
            print("error: delete")
        }
    }
    
}
