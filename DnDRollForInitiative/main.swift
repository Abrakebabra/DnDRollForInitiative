//
//  main.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/04.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation

//  add names, initiative, hitpoints, AC
//  If multiple initiative rolls are the same, then add dex
//  If dex is same, then give choice
//  Way to add new characters halfway through battle (if initiative is same, goes through same handling process if clashes with another character)
//  Way to temporarily/permanently remove characters from battle
//  Way to instantly remove/add hitpoints to/from any character
//  Status effects (text next to names such as concentration, frightened, poisoned - just add Kelsey's custom text next to name)
//  Option to show all characters, stats (and initiative?)  Need to know for status effects
//  [current character turns] [next set character turns, new characters introduced here]



//  help = show available commands
//  all = show all characters, order, stats,
//  add = new characters (and check)

/*
 Turn order:
 -----------
 
 */

//  Name: [Initiative: Int, Dex: Int, AC: Int, HP: Int, Status:]

//  Handle HP or participating status if defeated?  Options like unconscious or remove from battle?
//  Can HP go to negative?

var gameLog: [String] = []


func confirm() -> Bool {
    var awaitingInput: Bool = true
    
    while awaitingInput == true {
        let input: String? = readLine()
        
        if input == "y" {
            awaitingInput = false
            return true
        } else if input == "n" {
            awaitingInput = false
            return false
        }
    }
}


class Characters {
    let charName: String
    let initiative: Int
    var dexterity: Int?  //  can this change halfway through a battle?
    var hitPoints: Int
    var armorClass: Int  //  can this change halfway through a battle?
    var statuses: [String] = []
    var participating: Bool = true
    var changeLog: [String] = []

    
    init(name: String, ini: Int, HP: Int, AC: Int) {
        charName = name
        initiative = ini
        hitPoints = HP
        armorClass = AC
        changeLog.append("Character: \(name), Initiative: \(ini), HP: \(HP), AC: \(AC)")
        gameLog.append("\(name) has entered the fight with [\(HP) HP]!")
        print(changeLog.last as Any)
    }
    
    func sameInitiative(dex: Int) {
        print("Dexterity of [\(dex)] for \(charName)?")
        let result: Bool = confirm()
        if result == true {
            dexterity = dex
            changeLog.append("\(charName):  Dexterity stat added [\(dex)]")
            print(changeLog.last as Any)
        }
    }
    
    func addStatus(stat: String) {
        print("Add status effect of [\(stat)] to \(charName)?")
        let result: Bool = confirm()
        if result == true {
            statuses.append(stat)
            gameLog.append("\(charName) has status effect: [\(stat)]!")
            changeLog.append("\(charName) has status effect: [\(stat)]")
            print(changeLog.last as Any)
        }
    }
    
    func removeStatus(stat: String) {
        guard let index = self.statuses.firstIndex(of: stat) else {
            print("Status: [\(stat)] not found")
            return
        }
        self.statuses.remove(at: index)
        gameLog.append("\(charName) no longer has status effect: [\(stat)]!")
        changeLog.append("\(charName) no longer has status effect: [\(stat)]")
        print(changeLog.last as Any)
    }
    
    func modHitpoints(mod: String) {
        let cleanString: String = mod.replacingOccurrences(of: " ", with: "")
        
        if let modifier: Int = Int(cleanString) {
            
            if modifier > 0 {
                print("\(charName)'s HP: \(hitPoints) +\(abs(modifier)) -> [\(Int(hitPoints + modifier))]?")
                let result: Bool = confirm()
                
                if result == true {
                    hitPoints += modifier
                    gameLog.append("\(charName) has gained \(abs(modifier)) HP up to a total of [\(hitPoints)]")
                    changeLog.append("\(charName)'s HP: [\(hitPoints)] (gained \(modifier))")
                    print(changeLog.last as Any)
                }
                
            } else {
                print("\(charName)'s HP: \(hitPoints) -\(abs(modifier)) -> [\(Int(hitPoints + modifier))]?")
                let result: Bool = confirm()
                
                if result == true {
                    hitPoints += modifier
                    gameLog.append("\(charName) has lost \(abs(modifier)) HP down to a total of [\(hitPoints)]!")
                    changeLog.append("\(charName)'s HP: [\(hitPoints)] (lost \(abs(modifier))")
                }
            }
        }
    }
    
    func participant(trueFalse state: Bool) {
        if state == false {
            print("Remove \(charName) from battle?")
            let result = confirm()
            if result == true {
                participating = state
                gameLog.append("\(charName) is out of battle!")
                changeLog.append("\(charName) is removed from battle")
                print(changeLog.last as Any)
            }
        } else {
            print("Return \(charName) to battle?")
            let result = confirm()
            if result == true {
                participating = state
                gameLog.append("\(charName) is back in the fight!")
                changeLog.append("\(charName) is added back to battle")
                print(changeLog.last as Any)
            }
        }
    }
    
}

var order: [[String: Characters]] = []
var currentTurn: [[String: Characters]] = []  //  Copies order when finished all turns

