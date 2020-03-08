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
    
    @IBOutlet weak var searchBarView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var attackRangeSlider: RangeSlider!
    @IBOutlet weak var attackRangeLabel: UILabel!
    @IBOutlet weak var defenseRangeSlider: RangeSlider!
    
    @IBOutlet weak var defenseRangeLabel: UILabel!
    @IBOutlet weak var searchBarViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var starRangeLabel: UILabel!
    @IBOutlet weak var starRangeSlider: RangeSlider!
    
    
    @IBOutlet weak var searchBarViewTopConstraint: NSLayoutConstraint!
    
    
    var cardEntitys = Array<CardEntity>()
    var searchResult = Array<CardEntity>()
    var cardService = CardService()
    
    var attackLow: Int = 0
    var attackUp: Int = 10000
    
    var defenseLow: Int = 0
    var defenseUp: Int = 10000
    
    var starLow: Int = 0
    var starUp: Int = 12
    
    var rootFrame: CGSize = CGSize.zero
    var contentHeight: CGFloat = 0
    
    var searchType = NSMutableSet()
    var searchProperty = NSMutableSet()
    var searchRace = NSMutableSet()
    
    
    let types = [
        "通常","怪兽","特殊召唤",
        "效果","反转",
        "同盟","同调","灵摆","连接","XYZ","二重","调整","灵魂","卡通",
        "陷阱","反击",
        "魔法","装备","永续","融合","仪式","速攻","场地"
    ]
    
    let propertys = ["暗", "地", "神", "光", "风", "水", "炎"]
    
    let races = ["鱼", "幻龙", "兽战士", "岩石", "炎", "恐龙", "兽", "天使", "创造神", "机械", "植物", "魔法师", "龙", "昆虫", "战士", "念动力", "电子界", "鸟兽", "雷", "水", "幻神兽", "不死", "恶魔", "海龙", "爬虫类"]
    

    
    override func viewDidLoad() {
        setup()
        
        if isIPhoneX() {
            self.searchBarViewTopConstraint.constant = 10
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.searchBarView.contentSize = CGSize.init(width: rootFrame.width, height: contentHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        nc.addObserver(self, selector: #selector(CardSearchViewController.keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.searchBarViewHeightConstraint.constant = self.rootFrame.height - keyboardHeight
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        nc.removeObserver(self)
    }
    
    private func setup() {
        //
        self.inputField.returnKeyType = UIReturnKeyType.search
        self.searchBarView.contentSize.width = self.rootFrame.width
        
        
        //
        self.view.backgroundColor = darkColor
        self.searchBarView.backgroundColor = darkColor
        self.cancelButton.tintColor = UIColor.white
        self.cancelButton.addTarget(self, action: #selector(CardSearchViewController.clickCancelButton), for: .touchUpInside)
        
        self.inputField.attributedPlaceholder = NSAttributedString(string: "输入搜索（中/日/英 卡牌，效果，编号）", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
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
        setupTypeButtons()
    }
    
    private func setupTypeButtons() {
        
        //types
        var defaultHeight = 120
        defaultHeight = self.addButtons(datas: types, selector: #selector(clickTypeButton), dataWidth: 64, dataHeight: 32, dataDefaultHeight: defaultHeight)
        
        //propertys
        defaultHeight = self.addButtons(datas: propertys, selector: #selector(clickPropertyButton), dataWidth: 32, dataHeight: 32, dataDefaultHeight: defaultHeight + 32 + 8)
        
        //races
        defaultHeight = self.addButtons(datas: races, selector: #selector(clickRaceButton), dataWidth: 48, dataHeight: 32, dataDefaultHeight: defaultHeight + 32 + 8)
        
        
        self.contentHeight = CGFloat(defaultHeight + 32 + 16)

    }
    
    private func addButtons(datas: [String], selector: Selector,
                              dataWidth: Int, dataHeight: Int, dataDefaultHeight: Int
                              ) -> Int {
        let rootWidth = self.rootFrame.width
        let columnGap: Int = 8
        let rowGap: Int = 4
        
        var num = Int(rootWidth) / (dataWidth + columnGap)
        if num > datas.count {
            num = datas.count
        }
        let gap = (Int(rootWidth) - (dataWidth + columnGap) * num - columnGap) / 2 + columnGap
        
        var row = 0
        var column = 0
        
        var lastHeight: Int = 0
        
        
        for data in datas {
            let f = CGRect(x: gap + column * (dataWidth + columnGap), y: dataDefaultHeight + row * (dataHeight + rowGap), width: dataWidth, height: dataHeight)
            lastHeight = dataDefaultHeight + row * (dataHeight + rowGap)
            let button = DataButton(frame: f)
            button.layer.cornerRadius = 4
            button.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
            button.titleLabel?.font = attackRangeLabel.font
            button.backgroundColor = greyColor.withAlphaComponent(0.12)
            button.data = data
            button.setTitle(data, for: .normal)
            button.addTarget(self, action: selector, for: .touchUpInside)
            self.searchBarView.addSubview(button)
            
            column = column + 1
            if column == num {
                column = 0
                row = row + 1
            }
        }
        return lastHeight
        
    }
    
    private func clickButton(button: DataButton, set: NSMutableSet) {
        if button.backgroundColor == greyColor.withAlphaComponent(0.12) {
            button.backgroundColor = greyColor.withAlphaComponent(0.38)
            set.add(button.data)
        } else {
            button.backgroundColor = greyColor.withAlphaComponent(0.12)
            set.remove(button.data)
        }
    }
    
    
    @objc func clickTypeButton(button: DataButton) {
        self.clickButton(button: button, set: searchType)
    }
    
    @objc func clickPropertyButton(button: DataButton) {
        self.clickButton(button: button, set: searchProperty)
    }
    
    @objc func clickRaceButton(button: DataButton) {
        self.clickButton(button: button, set: searchRace)
    }
    
    
    
    private func setupRangeSlider() {
        setupRangeSliderStyle(rangeSlider: self.attackRangeSlider)
        self.attackRangeSlider.addTarget(self, action: #selector(CardSearchViewController.attackRangeSliderHandler), for: .valueChanged)
        self.attackRangeLabel.text = "攻 无限制"
        
        setupRangeSliderStyle(rangeSlider: self.defenseRangeSlider)
        self.defenseRangeSlider.addTarget(self, action: #selector(CardSearchViewController.defenseRangeSliderHandler), for: .valueChanged)
        self.defenseRangeLabel.text = "守 无限制"
        
        setupRangeSliderStyle(rangeSlider: self.starRangeSlider)
        self.starRangeSlider.addTarget(self, action: #selector(CardSearchViewController.starRangeSliderHandler), for: .valueChanged)
        self.starRangeLabel.text = "星 无限制"
    }
    
    private func setupRangeSliderStyle(rangeSlider: RangeSlider) {
        rangeSlider.trackTintColor = UIColor.clear
        rangeSlider.trackHighlightTintColor = UIColor.white.withAlphaComponent(0.70)
        rangeSlider.thumbBorderColor = UIColor.clear
        rangeSlider.thumbTintColor = greyColor
        
    }
    
    
    @objc func clickCancelButton() {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    @objc func attackRangeSliderHandler(sender: RangeSlider) {
        attackLow = Int(sender.lowerValue / 500) * 500
        attackUp = Int(sender.upperValue / 500) * 500
        
        if attackLow == 0 && attackUp == 10000 {
            attackRangeLabel.text = "攻 无限制"
        } else {
            attackRangeLabel.text = "攻 " + attackLow.description + " ~ " + attackUp.description
        }
        
    }
    
    @objc func defenseRangeSliderHandler(sender: RangeSlider) {
        defenseLow = Int(sender.lowerValue / 500) * 500
        defenseUp = Int(sender.upperValue / 500) * 500
        
        if defenseLow == 0 && defenseUp == 10000 {
            defenseRangeLabel.text = "守 无限制"
        } else {
            defenseRangeLabel.text = "守 " + defenseLow.description + " ~ " + defenseUp.description
        }
    }
    
    @objc func starRangeSliderHandler(sender: RangeSlider) {
        starLow = Int(sender.lowerValue)
        starUp = Int(sender.upperValue)
        
        if starLow == 0 && starUp == 12 {
            starRangeLabel.text = "星 无限制"
        } else {
            starRangeLabel.text = "星 " + starLow.description + " ~ " + starUp.description
        }
    }
    
    @objc(tableView:didSelectRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let controller = CardDetailViewController()
        controller.cardEntity = searchResult[indexPath.row]
        controller.proxy = self.tableView
        controller.hidesBottomBarWhenPushed = true
        
        let back = UIBarButtonItem()
        back.title = navigationBarTitleText
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


extension CardSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        hideRangeSlider(flag: false)
        
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchBarView.isScrollEnabled = false
        textField.resignFirstResponder()
        var result: Array<CardEntity> = []
        let input = textField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        //setLog(event: AnalyticsEventSearch, description: input)
    
        
        for i in 0 ..< cardEntitys.count {
            let c = cardEntitys[i]
            //input search
            if input != "" {
                let inputArray = input?.split(separator: " ")
                var inputFound = true
                for inputTmp in inputArray! {
                    if !c.titleChinese.lowercased().contains(inputTmp.description)
                        && !c.titleEnglish.lowercased().contains(inputTmp.description)
                        && !c.titleJapanese.lowercased().contains(inputTmp.description)
                        && !c.effect.lowercased().contains(inputTmp.description)
                        && !c.password.lowercased().contains(inputTmp.description) {
                        inputFound = false
                        break
                    }
                }
                if !inputFound {
                    continue
                }
            }
            
            //type search
            if searchType.count > 0 {
                var searchTypeFound = false
                
                for case let t as String in searchType {
                    if c.type.split(separator: " ").map(String.init).contains(t) {
                        searchTypeFound = true
                    }
                }
                
                if !searchTypeFound {
                    continue
                }
                
            }
            
            //race search
            if searchRace.count > 0 {
                if !searchRace.contains(c.race) {
                    continue
                }
            }
            
            
            //property search
            if searchProperty.count > 0 {
                if !searchProperty.contains(c.property) {
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
            
            //star search
            if starLow != 0 {
                if let star = Int.init(c.star) {
                    if star < starLow {
                        continue
                    }
                } else {
                    continue
                }
            }
            if starUp != 12 {
                if let star = Int.init(c.star) {
                    if star > starUp {
                        continue
                    }
                } else {
                    continue
                }
            }
            
            
            //
            result.append(c)
        }
    
        
        
        
        if result.count > 0 {
            self.searchResult = result
            self.tableView.reloadData()
        }
            
        
        hideRangeSlider(flag: true)
        self.searchBarViewHeightConstraint.constant = 56
        self.searchBarView.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
        
        return true
    }
    
    func hideRangeSlider(flag: Bool) {
        self.attackRangeSlider.isHidden = flag
        self.defenseRangeSlider.isHidden = flag
        self.starRangeSlider.isHidden = flag
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchResult = []
        self.tableView.reloadData()
        self.searchBarView.isScrollEnabled = true
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
        
        var result = (self.view.frame.width - materialGap * 2) / 3 / 160 * 230
        result = result + materialGap + ifLastRowWillAddGap
        
        return result
    }
   
    
    @objc(tableView:didEndDisplayingCell:forRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! CardTableViewCell).card.kf.cancelDownloadTask()
    }
    
    @objc(tableView:willDisplayCell:forRowAtIndexPath:)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = (cell as! CardTableViewCell)
        
        setImage(card: cell.card, id: searchResult[indexPath.row].id)
        
        
        
    }

    
}


extension CardSearchViewController: UITableViewDelegate {
    
}

