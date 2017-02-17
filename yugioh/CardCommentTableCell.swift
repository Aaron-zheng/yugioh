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
        self.commentLabel.text = commentEntity.content
    }
}
