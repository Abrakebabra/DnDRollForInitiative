//
//  characters.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/09.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation


class Characters {
    let charName: String
    let initiative: Int
    var dexterity: Int?  //  can this change halfway through a battle?
    var hitPoints: Int
    var maxHitPoints: Int
    var armorClass: Int  //  can this change halfway through a battle?
    var statuses: [String] = []
    var participating: Bool = true
    var changeLog: [String] = []
    var order: Int?  // battle order
    
    
    init(name: String, ini: Int, HP: Int, maxHP: Int, AC: Int) {
        charName = name
        initiative = ini
        hitPoints = HP
        maxHitPoints = maxHP
        armorClass = AC
        changeLog.append("Character: \(charName), Initiative: \(initiative)" +
            ", HP: \(hitPoints) / \(maxHitPoints), AC: \(armorClass)")
        gameLog.append("\(charName) has entered the fight with " +
            "[ \(hitPoints) / \(maxHitPoints) HP]!")
        print(changeLog.last as Any)
    }
    
    
    func sameInitiative(dex: Int) {
        print("Dexterity of [ \(dex) ] for \(charName)?  y/n")
        
        if confirm() == true {
            dexterity = dex
            changeLog.append("\(charName):  Dexterity stat added " +
                "[ \(dexterity as Any) ]")
            print(changeLog.last as Any)
        }
    }
    
    
    func addStatus(stat: String) {
        print("Add status effect of [ \(stat) ] to \(charName)?  y/n")
        
        if confirm() == true {
            statuses.append(stat)
            gameLog.append("\(charName) has status effect: [ \(stat) ]!")
            changeLog.append("\(charName) has status effect: [ \(stat) ]")
            print(changeLog.last as Any)
        }
    }
    
    
    func removeStatus(stat: String) {
        guard let index = statuses.firstIndex(of: stat) else {
            print("Status: [ \(stat) ] not found")
            return
        }
        
        print("Remove status effect of [ \(stat) ] from \(charName)?  y/n")
        
        if confirm() == true {
            self.statuses.remove(at: index)
            gameLog.append("\(charName) no longer has status effect: " +
                "[ \(stat) ]!")
            changeLog.append("\(charName) no longer has status effect: " +
                "[ \(stat) ]")
            print(changeLog.last as Any)
        }
        
    }
    
    
    func participant(trueFalse state: Bool) {
        
        if state == false {
            print("Remove \(charName) from battle?")
            
            if confirm() == true {
                participating = state
                gameLog.append("\(charName) is out of battle!")
                changeLog.append("\(charName) is removed from battle")
                print(changeLog.last as Any)
            }
            
        } else {
            print("Return \(charName) to battle?")
            
            if confirm() == true {
                participating = state
                gameLog.append("\(charName) is back in the fight!")
                changeLog.append("\(charName) is added back to battle")
                print(changeLog.last as Any)
            }
        }
    }
    
    // Might no longer be a String.  Likely Integer input.
    func modHitpoints(mod: Int) {
        
        //  handle going over max as choice
        //  perhaps a confirmation choice that will go over max
        
        
        
        func gainHP(change: Int) {
            
            if hitPoints + change > maxHitPoints {
                print("-****- Hit points will be above maximum -****-")
            }
            
            print("\(charName)'s HP: \(hitPoints) +\(abs(change)) " +
                "-> [ \(Int(hitPoints + change)) / \(maxHitPoints) ]?  y/n")
            
            if confirm() == true {
                hitPoints += change
                gameLog.append("\(charName) has gained \(abs(change)) " +
                    "HP up to a total of [ \(hitPoints) ]")
                changeLog.append("\(charName)'s HP: [ \(hitPoints) ] " +
                    "(gained \(change))")
                print(changeLog.last as Any)
            }
        }
        
        
        func zeroOrBelowHP() {
            var awaitingInputA: Bool = true
            
            while awaitingInputA == true {
                print("\(charName) has lost all hitpoints.")
                print("[r]emove or [u]nconscious?")
                var awaitingInputB: Bool = true
                
                while awaitingInputB == true {
                    let input: String? = readLine()
                    
                    if input == "r" {
                        participant(trueFalse: false)
                        
                        //  if positive confirmation given in participant()
                        if participating == false {
                            awaitingInputA = false
                        }
                        awaitingInputB = false
                        
                    } else if input == "u" {
                        hitPoints = 0
                        addStatus(stat: "Unconscious")
                        
                        //  if positive confirmation given in addStatus()
                        if statuses.firstIndex(of: "Unconscious") != nil {
                            awaitingInputA = false
                        }
                        awaitingInputB = false
                    }
                }
            }
        }
        
        
        func loseHP(change: Int) {
            print("\(charName)'s HP: \(hitPoints) -\(abs(change)) " +
                "-> [ \(Int(hitPoints + change)) ]?  y/n")
            
            if confirm() == true {
                hitPoints += change
                if hitPoints > 0 {
                    gameLog.append("\(charName) has lost \(abs(change)) " +
                        "HP down to a total of [ \(hitPoints) ]!")
                    changeLog.append("\(charName)'s HP: [ \(hitPoints) ] " +
                        "(lost \(abs(change))")
                } else {
                    zeroOrBelowHP()
                }
            }
        }

        if mod > 0 {
            gainHP(change: mod)
            
        } else {
            loseHP(change: mod)
        }
    }
    
}