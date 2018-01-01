//
//  CardCommentTableCell.swift
//  yugioh
//
//  Created by Aaron on 17/2/2017.
//  Copyright © 2017 sightcorner. All rights reserved.
//

import Foundation
import UIKit

class CardCommentTableCell: UITableViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    
    
    func prepare(commentEntity: CommentEntity) {
        var username = commentEntity.userName
        if username.count <= 0 {
            username = "路人"
        } else {
            username = "[No." + username + "]用户"
        }
        self.commentLabel.text = username + "：" + commentEntity.content
    }
}
