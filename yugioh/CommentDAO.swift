//
//  CommentDAO.swift
//  yugioh
//
//  Created by Aaron on 17/2/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation
import Wilddog

class CommentDAO {
    
    private let idPrefix: String = "id_"
    private let urlPrefix: String = "comment/"
    
    func addComment(commentEntity: CommentEntity) {
        let options = WDGOptions.init(syncURL: wilddogUrl)
        WDGApp.configure(with: options!)
        let ref = WDGSync.sync().reference()
        let message = ref.child(urlPrefix).child(idPrefix + commentEntity.id)
        message.childByAutoId().setValue(["content": commentEntity.content, "timestamp": commentEntity.timestamp])
    }
    
    
    func getComment(id: String, callback: @escaping (Array<CommentEntity>) -> Void){
        let options = WDGOptions.init(syncURL: wilddogUrl + urlPrefix + idPrefix + id)
        WDGApp.configure(with: options!)
        let ref = WDGSync.sync().reference()
        var result = Array<CommentEntity>()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dict = snapshot.value as? NSDictionary {
                
                let keys = dict.allKeys
                
                for key in keys {
                    let obj = dict[key] as! NSDictionary
                    let commentEntity = CommentEntity()
                    commentEntity.key = key as! String
                    if let content = obj["content"] as? String {
                        commentEntity.content = content
                    }
                    result.append(commentEntity)
                }
                
                result.sort(by: { (commentEntity1, commentEntity2) -> Bool in
                    return commentEntity1.key > commentEntity2.key
                })
                
                
                callback(result)
                
            }
            
        })
        
        
    }
}
