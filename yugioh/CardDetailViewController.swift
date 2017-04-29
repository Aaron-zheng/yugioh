//
//  CardDetailViewController.swift
//  yugioh
//
//  Created by Aaron on 25/10/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


class CardDetailViewController: UIViewController {
    
    @IBOutlet weak var card: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var effect: UIVerticalAlignLabel!
    @IBOutlet weak var star: UIButton!
    @IBOutlet weak var attack: UILabel!
    @IBOutlet weak var pack: UIVerticalAlignLabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBOutlet weak var commentInputTextField: UITextField!
    
    var cardEntity: CardEntity!
    var commentEntitys: Array<CommentEntity>! = []
    var proxy: UITableView!
    
    fileprivate var commentDAO = CommentService()
    
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = greyColor
        let frameWidth = self.proxy.frame.width
        
        self.pack.verticalAligment = .VerticalAligmentBottom
        
        let h1 = preCalculateTextHeight(text: cardEntity.effect, font: effect.font, width: (frameWidth - materialGap * 2) / 3 * 2 - materialGap * 2) + 36
        let h2 = (frameWidth - materialGap * 2) / 3 / 160 * 230 - materialGap * 7.5
        if h1 > h2 {
            self.heightConstraint.constant = h1 - h2
        }
        prepare()
        
        
    }
    
    private func prepareTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = greyColor
        self.tableView.separatorStyle = .singleLine
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.register(CardCommentTableCell.NibObject(), forCellReuseIdentifier: CardCommentTableCell.identifier())
        
        retriveComment()
    }
    
    
    func retriveComment() {
        commentDAO.getComment(id: cardEntity.id) { (commentEntitys) in
            self.commentEntitys = commentEntitys
            self.commentCountLabel.text = "评论 (" + commentEntitys.count.description + ")"
            self.tableView.reloadData()
        }
    }
    
    @IBAction func clickStarButton(_ sender: UIButton) {
        
        if sender.tintColor == greyColor {
            sender.tintColor = yellowColor
            cardEntity.isSelected = true
        } else {
            sender.tintColor = greyColor
            cardEntity.isSelected = false
        }
        
        
        
        nc.post(name: Notification.Name("clickStarButton"), object: nil,
                userInfo: [
                    "data": cardEntity,
                    "tableView": self.proxy
            ])
    }
    
    
    public func prepare() {
        let img = UIImage(named: "ic_star_white")?.withRenderingMode(.alwaysTemplate)
        star.setImage(img, for: .normal)
        if cardEntity.isSelected {
            star.tintColor = yellowColor
        } else {
            star.tintColor = greyColor
        }
        
        self.name.text = cardEntity.titleChinese
        self.effect.text = cardEntity.effect
        if cardEntity.star.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            self.type.text = cardEntity.type + " (" + cardEntity.star + "星)"
        } else {
            self.type.text = cardEntity.type
        }
        if cardEntity.attack.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 && cardEntity.defense.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            self.attack.text = cardEntity.attack + " / " + cardEntity.defense
        } else {
            self.attack.text = ""
        }
        self.pack.text = "卡包: " + cardEntity.pack
        
        
        setImage(card: self.card, url: cardEntity.url)
                
        prepareTableView()
        
        self.commentInputTextField.delegate = self
    }
    
    
}

extension CardDetailViewController: UITableViewDataSource {
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return commentEntitys.count
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CardCommentTableCell.identifier(), for: indexPath) as! CardCommentTableCell
        cell.prepare(commentEntity: commentEntitys[indexPath.row])
        
        return cell
    }

}

extension CardDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension CardDetailViewController: UITextFieldDelegate {
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let input = textField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if input != nil && input != "" {
            
            let commentEntity = CommentEntity()
            commentEntity.content = input!
            commentEntity.id = cardEntity.id
            self.commentDAO.addComment(commentEntity: commentEntity, callback: {
                self.retriveComment()
            })
        }
        
        textField.text = ""
        
        return true
    }
    
}
