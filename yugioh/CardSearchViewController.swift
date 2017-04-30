//
//  CardSearchViewController.swift
//  yugioh
//
//  Created by Aaron on 2/11/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit

class CardSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var attackRangeSlider: RangeSlider!
    @IBOutlet weak var attackRangeLabel: UILabel!
    @IBOutlet weak var defenseRangeSlider: RangeSlider!
    @IBOutlet weak var defenseRangeLabel: UILabel!
    
    var cardEntitys = Array<CardEntity>()
    var searchResult = Array<CardEntity>()
    var cardService = CardService()
    
    var attackLow: Int = 0
    var attackUp: Int = 10000
    
    var defenseLow: Int = 0
    var defenseUp: Int = 10000
    
    override func viewDidLoad() {
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setup() {
        self.view.backgroundColor = darkColor
        self.searchBarView.backgroundColor = darkColor
        self.cancelButton.tintColor = UIColor.white
        self.cancelButton.addTarget(self, action: #selector(CardSearchViewController.clickCancelButton), for: .touchUpInside)
        
        self.inputField.attributedPlaceholder = NSAttributedString(string: "搜索卡牌、效果（当前卡包）", attributes: [NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.70)])
        self.inputField.textColor = UIColor.white
        self.inputField.text = nil
        self.inputField.becomeFirstResponder()
        self.inputField.delegate = self
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CardTableViewCell.NibObject(), forCellReuseIdentifier: CardTableViewCell.identifier())
        self.tableView.backgroundColor = greyColor
        self.tableView.separatorStyle = .none
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupRangeSlider()
    }
    
    private func setupRangeSlider() {
        setupRangeSliderStyle(rangeSlider: self.attackRangeSlider)
        self.attackRangeSlider.addTarget(self, action: #selector(CardSearchViewController.attackRangeSliderHandler), for: .valueChanged)
        self.attackRangeLabel.text = "攻 无限制"
        
        setupRangeSliderStyle(rangeSlider: self.defenseRangeSlider)
        self.defenseRangeSlider.addTarget(self, action: #selector(CardSearchViewController.defenseRangeSliderHandler), for: .valueChanged)
        self.defenseRangeLabel.text = "守 无限制"
    }
    
    private func setupRangeSliderStyle(rangeSlider: RangeSlider) {
        rangeSlider.trackTintColor = UIColor.clear
        rangeSlider.trackHighlightTintColor = UIColor.white.withAlphaComponent(0.70)
        rangeSlider.thumbBorderColor = UIColor.clear
        rangeSlider.thumbTintColor = greyColor
        
    }
    
    
    func clickCancelButton() {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    func attackRangeSliderHandler(sender: RangeSlider) {
        attackLow = Int(sender.lowerValue / 500) * 500
        attackUp = Int(sender.upperValue / 500) * 500
        
        if attackLow == 0 && attackUp == 10000 {
            attackRangeLabel.text = "攻 无限制"
        } else {
            attackRangeLabel.text = "攻 " + attackLow.description + " ~ " + attackUp.description
        }
        
    }
    
    func defenseRangeSliderHandler(sender: RangeSlider) {
        defenseLow = Int(sender.lowerValue / 500) * 500
        defenseUp = Int(sender.upperValue / 500) * 500
        
        if defenseLow == 0 && defenseUp == 10000 {
            defenseRangeLabel.text = "守 无限制"
        } else {
            defenseRangeLabel.text = "守 " + defenseLow.description + " ~ " + defenseUp.description
        }
    }
    
    
    @objc(tableView:didSelectRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let controller = CardDetailViewController()
        controller.cardEntity = searchResult[indexPath.row]
        controller.proxy = self.tableView
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


extension CardSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        hideRangeSlider(flag: false)
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        var result: Array<CardEntity> = []
        let input = textField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if input != "" || attackLow != 0 || attackUp != 10000 || defenseLow != 0 || defenseUp != 10000{
        
            for i in 0 ..< cardEntitys.count {
                let c = cardEntitys[i]
                //input search
                if input != "" {
                    if !c.titleChinese.lowercased().contains(input!) && !c.effect.lowercased().contains(input!) {
                        continue
                    }
                }
                
                //attack search
                if attackLow != 0 {
                    if let attack = Int.init(c.attack) {
                        if attack < attackLow {
                            continue
                        }
                    } else {
                        continue
                    }
                }
                if attackUp != 10000 {
                    if let attack = Int.init(c.attack) {
                        if attack > attackUp {
                            continue
                        }
                    } else {
                        continue
                    }
                }
                
                
                //defense search
                if defenseLow != 0 {
                    if let defense = Int.init(c.defense) {
                        if defense < defenseLow {
                            continue
                        }
                    } else {
                        continue
                    }
                }
                if defenseUp != 10000 {
                    if let defense = Int.init(c.defense) {
                        if defense > defenseUp {
                            continue
                        }
                    } else {
                        continue
                    }
                }
                
                
                
                //
                result.append(c)
            }
        }
        
        
        
        
        
        if result.count > 0 {
            self.searchResult = result
            self.tableView.reloadData()
        }
            
        
        hideRangeSlider(flag: true)
        
        return true
    }
    
    func hideRangeSlider(flag: Bool) {
        self.attackRangeSlider.isHidden = flag
        self.defenseRangeSlider.isHidden = flag
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchResult = []
        self.tableView.reloadData()
        
    }
    
    
    
}


extension CardSearchViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResult.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identifier(), for: indexPath) as! CardTableViewCell
        let cardEntity = searchResult[indexPath.row]
        cardEntity.isSelected = false
        let list = cardService.list()
        for i in 0 ..< list.count {
            if cardEntity.id == list[i] {
                cardEntity.isSelected = true
                break
            }
        }
        
        
        cell.prepare(cardEntity: cardEntity, tableView: tableView, indexPath: indexPath)
        return cell
    }
    
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var ifLastRowWillAddGap: CGFloat = 0
        if indexPath.row == searchResult.count - 1 {
            ifLastRowWillAddGap = 8
        }
        
        return (self.view.frame.width - materialGap * 2) / 3 / 160 * 230 + materialGap + ifLastRowWillAddGap
    }
   
    
    @objc(tableView:didEndDisplayingCell:forRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! CardTableViewCell).card.kf.cancelDownloadTask()
    }
    
    @objc(tableView:willDisplayCell:forRowAtIndexPath:)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = (cell as! CardTableViewCell)
        
        
        setImage(card: cell.card, url: searchResult[indexPath.row].url)
        
        
        
    }

    
}


extension CardSearchViewController: UITableViewDelegate {
    
}

