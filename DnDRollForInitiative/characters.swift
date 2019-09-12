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
        changeLog.append("Character \(charName)    Initiative (initiative)    " +
            "HP \(hitPoints)/\(maxHitPoints)    AC \(armorClass)")
        gameLog.append("\(charName) has entered the fight with " +
            "[\(hitPoints) / \(maxHitPoints) HP]!")
    }
    
    
    func sameInitiative(dex: Int) {
        print("Dexterity of [\(dex)] for \(charName)?\ny / n")
        
        if confirm() == true {
            dexterity = dex
            changeLog.append("\(charName)'s Dex: \(dexterity!)")
        }
    }
    
    
    func addStatus(stat: String) {
        print("\(charName):  Add status effect [\(stat)]?\ny / n")
        
        if confirm() == true {
            statuses.append(stat)
            gameLog.append("\(charName) has status effect [\(stat)]!")
            changeLog.append("\(charName) has status effect [\(stat)]")
            printLastChange(characterName: charName)
        } else {
            print("Add [\(stat)] cancelled")
        }
    }
    
    
    func removeStatus(stat: String) {
        guard let index = statuses.firstIndex(of: stat) else {
            print("[\(stat)] not found")
            return
        }
        
        //  No need for confirmation of removal.  Hard to accidentally do this.
        self.statuses.remove(at: index)
        gameLog.append("\(charName) no longer has status effect " +
            "[\(stat)]!")
        changeLog.append("\(charName) no longer has status effect " +
            "[\(stat)]")
        printLastChange(characterName: charName)
    }
    
    
    func inBattle(trueFalse state: Bool) {
        
        //  Return character to battle
        if state == true {
            
            if participating == true {
                print("\(charName) is already in battle")
                return
            }

            participating = state
            gameLog.append("\(charName) is back in the fight!")
            changeLog.append("\(charName) is returned to battle")
            printLastChange(characterName: charName)
        
        //  Remove character from battle
        } else {
            
            if participating == false {
                print("\(charName) is already out of battle")
                return
            }
            
            participating = state
            gameLog.append("\(charName) is out of battle!")
            changeLog.append("\(charName) is out of battle")
            printLastChange(characterName: charName)
        }
    }
    
    
    func modHitPoints(mod: Int) {
        
        
        func hpCalcAboveMax(change: Int) {
            var awaitingInput: Bool = true
            
            while awaitingInput == true {
                print("\(charName)'s HP will go beyond max HP " +
                    "(\(hitPoints + change)/\(maxHitPoints))\n" +
                    "[m]ax or [b]eyond?")
                let input: String? = readLine()
                
                //  Set hp to max hit points
                if input == "m" {
                    hitPoints = maxHitPoints
                    
                    gameLog.append("\(charName) has gained " +
                        "\(maxHitPoints - hitPoints) " +
                        "HP up to a total of \(hitPoints)/\(maxHitPoints)")
                    changeLog.append("\(charName)'s HP:  \(hitPoints) " +
                        "(gained \(maxHitPoints - hitPoints))")
                    printLastChange(characterName: charName)
                    awaitingInput = false
                    
                    //  Let hp go beyond max hit points
                } else if input == "b" {
                    hitPoints += change
                    
                    gameLog.append("\(charName) has gained \(abs(change)) " +
                        "HP up to a total of \(hitPoints)/\(maxHitPoints)!")
                    changeLog.append("\(charName)'s HP:  \(hitPoints) " +
                        "(gained \(change), \(hitPoints - maxHitPoints) " +
                        "beyond max!")
                    printLastChange(characterName: charName)
                    
                    awaitingInput = false
                }
            }
        }
        
        
        func zeroOrBelowHP() {
            var awaitingInputA: Bool = true
            
            while awaitingInputA == true {
                print("\(charName) has lost all hitpoints.")
                print("[r]emove or [u]nconscious?")
                
                let input: String? = readLine()
                
                if input == "r" {
                    inBattle(trueFalse: false)
                    awaitingInputA = false
                    
                } else if input == "u" {
                    hitPoints = 0
                    statuses.insert("Unconscious", at: 0)
                    gameLog.append("\(charName) is unconscious!!")
                    changeLog.append("\(charName) is unconscious!!")
                    awaitingInputA = false
                }
                
            }
        }
        
        
        func gainHP(change: Int) {
            
            //  HP change would bring character above max
            if hitPoints + change > maxHitPoints {
                hpCalcAboveMax(change: change)
            
            //  Normal HP gain
            } else {
                
                print("\(charName) +\(abs(change)) hit points?\ny / n")
                
                if confirm() == true {
                    hitPoints += change
                    gameLog.append("\(charName) has gained \(abs(change)) " +
                        "HP up to a total of \(hitPoints)/\(maxHitPoints)")
                    changeLog.append("\(charName)'s HP \(hitPoints) " +
                        "(gained \(change))")
                }
            }
        }
        
        
        func loseHP(change: Int) {
            print("\(charName) -\(abs(change)) hit points?\ny / n")
            
            if confirm() == true {
                hitPoints += change
                
                //  Normal HP loss
                if hitPoints > 0 {
                    gameLog.append("\(charName) has lost \(abs(change)) " +
                        "HP down to a total of \(hitPoints)/\(maxHitPoints)!")
                    changeLog.append("\(charName)'s HP \(hitPoints) " +
                        "(lost \(abs(change))")
                    
                //  HP loss brings character to 0 or below
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
