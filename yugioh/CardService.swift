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
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContex = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContex)!
        fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: false)]
    }
    
    
    func list() -> [String] {
        var result = [String]()
        do {
            let r = try managedContex.fetch(fetchRequest)
            
            
            for i in 0 ..< r.count {
                let version = r[i].value(forKey: "version") as? String
                if version == nil {
                    managedContex.delete(r[i])
                    continue
                }
                let id = r[i].value(forKey: "id") as? String
                result.append(id!)
            }
        } catch {
            print("error: list")
        }
        
        return result
        
    }
    
    
    
    func delete(id: String) {
        do {
            let result = try managedContex.fetch(fetchRequest)
            for i in 0 ..< result.count {
                if id == (result[i].value(forKey: "id") as! String) {
                    managedContex.delete(result[i])
                }
            }
            
            try managedContex.save()
            
        } catch {
            print("error: delete")
        }
    }
    
    func isExist(id: String) -> Bool {
        var flag = false
        do {
            let result = try managedContex.fetch(fetchRequest)
            for i in 0 ..< result.count {
                let resultId = result[i].value(forKey: "id") as? String
                if resultId == nil {
                    continue
                }
                if id == resultId {
                    flag = true
                    break
                }
            }
        } catch {
            print("error: isExist")
        }
        
        return flag
        
    }
    
    
    func save(id: String) {
        
        if isExist(id: id) {
            return
        }
        
        let card = CardPO(entity: entity, insertInto: managedContex)
        card.id = id
        card.createAt = Date()
        card.version = "1"
        do {
            try managedContex.save()
        } catch {
            print("error: save")
        }
    }
    
    
}
