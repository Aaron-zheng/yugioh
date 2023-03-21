//
//  CardEntity.swift
//  yugioh
//
//  Created by Aaron on 21/10/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation

class CardEntity {
    
    // 唯一标识
    var id: String! = ""
    //
    var enName: String! = ""
    var frName: String! = ""
    var deName: String! = ""
    var itName: String! = ""
    var ptName: String! = ""
    var cnName: String! = ""
    var jpName: String! = ""
    //
    var enDesc: String! = ""
    var frDesc: String! = ""
    var deDesc: String! = ""
    var itDesc: String! = ""
    var ptDesc: String! = ""
    var cnDesc: String! = ""
    var jpDesc: String! = ""
    
    //
    var archetype: String! = ""
    
    //
    var frameType: String! = ""
    
    // 种族，鸟兽，念动力，等等
    var race: String! = ""
    
    // 类型，空格隔离
    var type: String! = ""
    
    // 属性，光，暗，风，等灯
    var attribute: String! = ""
    
    //
    var cardImages: String! = ""
    
    //
    var cardPrices: String! = ""
    
    //
    var cardSets: String! = ""
    
    // 攻击力
    var atk: String! = ""
    
    // 防御力
    var def: String! = ""
    
    // 星级
    var level: String! = ""
    
    // 灵摆，数字表示
    var scale: String! = ""
    
    
    // 连接，数字表示
    var linkval: String! = ""
    
    // 连接标记，大概为 左上，左下
    var linkmarkers: String! = ""
    
    //
    var banlistInfo: String! = ""
    
    // 额外添加属性
    // var url: String! = ""
    var isSelected: Bool = false
    
    
    func getId() -> String {
        return id;
    }
    
    
    func getName() -> String! {
        var r = "";
        if(language == "en") {
            r = enName;
        }
        if(language == "cn") {
            r = cnName;
        }
        if(r == "") {
            return "-";
        }
        return r;
    }
    
    func getDesc() -> String! {
        var r = ""
        if(language == "en") {
            r = enDesc;
        }
        if(language == "cn") {
            r = cnDesc
        }
        
        if(r == "") {
            return "-";
        }
        return r;
    }
    
    
    func getArchetype() -> String! {
        var r = ""
        if(language == "en") {
            r = archetype;
        }
        if(language == "cn") {
            
        }
        
        if(r == "") {
            return "-";
        }
        return r;
    }
    
    func getFrameType() -> String! {
        return frameType;
    }
    
    func getRace() -> String!  {
        
        
        var r = ""
        if(language == "en") {
            r = race;
        }
        if(language == "cn") {
            if(race == "Aqua") {r=""}
            if(race == "Beast") {r="兽"}
            if(race == "Beast-Warrior") {r="兽战士"}
            if(race == "Continuous") {r="永续"}
            if(race == "Counter") {r="反击"}
            if(race == "Creator-God") {r="创造神"}
            if(race == "Cyberse") {r="电子界"}
            if(race == "Dinosaur") {r="恐龙"}
            if(race == "Divine-Beast") {r="幻神兽"}
            if(race == "Dragon") {r="龙"}
            if(race == "Equip") {r="装备"}
            if(race == "Fairy") {r=""}
            if(race == "Field") {r=""}
            if(race == "Fiend") {r=""}
            if(race == "Fish") {r="鱼"}
            if(race == "Insect") {r="昆虫"}
            if(race == "Machine") {r="机械"}
            if(race == "Normal") {r="通常"}
            if(race == "Plant") {r="植物"}
            if(race == "Psychic") {r="念动力"}
            if(race == "Pyro") {r="炎"}
            if(race == "Quick-Play") {r="速攻"}
            if(race == "Reptile") {r="爬虫类"}
            if(race == "Ritual") {r=""}
            if(race == "Rock") {r="岩石"}
            if(race == "Sea Serpent") {r="海龙"}
            if(race == "Spellcaster") {r=""}
            if(race == "Thunder") {r="雷"}
            if(race == "Warrior") {r="战士"}
            if(race == "Winged Beast") {r=""}
            if(race == "Wyrm") {r="幻龙"}
            if(race == "Zombie") {r="不死"}
            
        }
        return r;
    }
    
    func getType() -> String!  {
        
        var r = ""
        if(language == "en") {
            r = type;
        }
        if(language == "cn") {
            r = type
            .replacingOccurrences(of: "Effect", with: "效果")
            .replacingOccurrences(of: "Monster", with: "怪兽")
            .replacingOccurrences(of: "Flip", with: "反转")
            .replacingOccurrences(of: "Fusion", with: "融合")
            .replacingOccurrences(of: "Gemini", with: "二重")
            .replacingOccurrences(of: "Link", with: "连接")
            .replacingOccurrences(of: "Normal", with: "通常")
            .replacingOccurrences(of: "Tuner", with: "调整")
            .replacingOccurrences(of: "Pendulum", with: "灵摆")
            .replacingOccurrences(of: "Ritual", with: "仪式")
            .replacingOccurrences(of: "Skill Card", with: "技能")
            .replacingOccurrences(of: "Spell Card", with: "魔法")
            .replacingOccurrences(of: "Spirit", with: "灵魂")
            .replacingOccurrences(of: "Synchro", with: "同调")
            .replacingOccurrences(of: "Token", with: "Token")
            .replacingOccurrences(of: "Toon", with: "卡通")
            .replacingOccurrences(of: "Trap Card", with: "陷阱")
            .replacingOccurrences(of: "Union", with: "同盟")
            .replacingOccurrences(of: "XYZ", with: "XYZ")
        }
    
        return r;
    }
    
    func getAttribute() -> String!  {
        
        var r = ""
        if(language == "en") {
            r = attribute;
        }
        if(language == "cn") {
            if(attribute == "DARK") {
                r = "暗"
            }
            if(attribute == "DIVINE") {
                r = "神"
            }
            if(attribute == "EARTH") {
                r = "地"
            }
            if(attribute == "FIRE") {
                r = "炎"
            }
            if(attribute == "LIGHT") {
                r = "光"
            }
            if(attribute == "WATER") {
                r = "水"
            }
            if(attribute == "WIND") {
                r = "风"
            }

        }
        
        
        return r;
    }
    
    func getCardImages() -> String {
        return cardImages;
    }
    
    func getCardPrices() -> String {
        return cardPrices;
    }
    
    func getCardSets() -> String {
        return cardSets;
    }
    
    func getAtk() -> String {
        return atk;
    }
    
    func getDef() -> String {
        return def;
    }
    
    func getLevel() -> String {
        return level;
    }
    
    func getScale() -> String {
        return scale;
    }
    
    func getLinkval() -> String {
        return linkval;
    }
    
    func getLinkmarkers() -> String {
        return linkmarkers;
    }
    
    func getBanlistInfo() -> String {
        return banlistInfo;
    }
    
    func getBanlistInfoText() -> String {
        // 禁止，限制，准限制，无限制
        var r = ""
        if(banlistInfo == nil || banlistInfo == "") {
            if(language == "en") {
                r = "";
            }
            if(language == "cn") {
                r = "无限制"
            }
        } else {
            
        }
        
        return r;
    }
}
