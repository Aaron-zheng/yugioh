//
//  CommentDAO.swift
//  yugioh
//
//  Created by Aaron on 17/2/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation
import LeanCloud

class CommentService {
    
    
    
    func addComment(commentEntity: CommentEntity, callback: @escaping () -> Void) {
        
        let post = LCObject(className: "Comment")
        post.set("id", value: commentEntity.id)
        post.set("content", value: commentEntity.content)
        post.save { (result) in
            switch result {
            case .success :
                callback()
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getComment(id: String, callback: @escaping (Array<CommentEntity>) -> Void){
        
        let query = LCQuery(className: "Comment")
        query.whereKey("createdAt", .descending)
        query.whereKey("id", .equalTo(id))
        query.find { (result) in
            switch result {
            case .success(let objects):
                
                var result = Array<CommentEntity>()
                for obj in objects {
                    let commentEntity = CommentEntity()
                    commentEntity.id = (obj.get("id") as! LCString).jsonString
                    commentEntity.content = (obj.get("content") as! LCString).jsonString
                    result.append(commentEntity)
                }
                callback(result)
                
                break
            case .failure(let error):
                print(error)
                break
            }
            
        }
        
    }
}
