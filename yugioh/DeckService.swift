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
    
    func conversion() {
        do {
            let result = try managedContex.fetch(fetchRequest)
            for i in 0 ..< result.count {
                let deckPO = result[i] as! DeckPO
                if deckPO.type == nil {
                    deckPO.type = "0"
                }
            }
            try managedContex.save()
        } catch {
            print("error: conversion")
        }
    }
    
    
    func list() -> [String: [DeckEntity]] {
        var result = [String: [DeckEntity]]()
        result["0"] = []
        result["1"] = []
        result["2"] = []
        do {
            let r = try managedContex.fetch(fetchRequest)
            for i in 0 ..< r.count {
                let d = DeckEntity()
                d.id = r[i].value(forKey: "id") as! String
                d.number = Int(truncating: r[i].value(forKey: "number") as! NSNumber)
                d.type = r[i].value(forKey: "type") as! String
                result[d.type]!.append(d)
            }
        } catch {
            print("error: list")
        }
        
        return result
        
    }
    
    
    
    
    private func isExist(id: String, type: String) -> DeckPO? {
        
        do {
            let result = try managedContex.fetch(fetchRequest)
            for i in 0 ..< result.count {
                if id == (result[i].value(forKey: "id") as! String) &&
                    type == (result[i].value(forKey: "type") as! String) {
                    return (result[i] as! DeckPO)
                }
            }
        } catch {
            print("error: isExist")
        }
        
        return nil
        
    }
    
    
    func save(id: String, type: String) {
        
        if let existedDeck = isExist(id: id, type: type) {
            if existedDeck.number.intValue >= 3  {
                return
            }
            existedDeck.number = (existedDeck.number.intValue + 1) as NSNumber
        } else {
            let deck = DeckPO(entity: entity, insertInto: managedContex)
            deck.id = id
            deck.number = 1
            deck.type = type
        }
        
        do {
            try managedContex.save()
        } catch {
            print("error: save")
        }
    }
    
    
    func delete(id: String, type: String) {
        if let existedDeck = isExist(id: id, type: type) {
            
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
