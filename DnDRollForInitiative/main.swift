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

//  Consider adding max HP?  Might take away from the game if entering too much info

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
    var maxHitPoints: Int
    var armorClass: Int  //  can this change halfway through a battle?
    var statuses: [String] = []
    var participating: Bool = true
    var changeLog: [String] = []

    
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
    
    
    func modHitpoints(mod: String) {
        
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
        
        let cleanString: String = mod.replacingOccurrences(of: " ", with: "")

        if let modifier: Int = Int(cleanString) {
            
            if modifier > 0 {
                gainHP(change: modifier)
                
            } else {
                loseHP(change: modifier)
            }
        }
    }

}

var charOrder: [[String: Characters]] = []
var currentTurn: [[String: Characters]] = []  //  Copies order when finished all turns


func inputToCommands(input: String) {
    
    
    //  -- tool functions:  strToInt, identifyInputs, extractInputs --
    
    func strToInt(userInput: String) -> Int {
        if let inputInt: Int = Int(userInput) {
            return inputInt
        } else {
            print("Integer not found where expected.  Check format?")
        }
    }
    
    
    func identifyInputs(input: String, lookFor: String) -> Bool {
        let startIndex = input.index(input.startIndex, offsetBy: 0)
        let endIndex = input.index(input.startIndex, offsetBy: lookFor.count)
        let identifier: String = String(input[startIndex..<endIndex])
        
        if lookFor == identifier {
            return true
        } else {
            print("Need to know what each number is for")
            return false
        }
    }
    
    
    func extractInputs(input: String, identifier: String) -> String {
        let startIndex = input.index(input.startIndex, offsetBy: identifier.count)
        let endIndex = input.index(input.endIndex, offsetBy: 0)
        let extracted: String = String(input[startIndex..<endIndex])
        
        return extracted
    }
    
    //  ---- end of tool functions --
    
    
    let inputCap: String = input.capitalized
    let commands: [String] = inputCap.components(separatedBy: " ")
    
    
    
    
    func new(inputs: [String]) {
        let charName: String = commands[1]
        let initiative: Int
        let hp: Int
        let maxHP: Int
        let ac: Int
        
        
        if identifyInputs(input: commands[2], lookFor: "I") == true {
            let iData: String = extractInputs(input: commands[2], identifier: "I")
            if let iDataInt: Int = Int(iData) {
                initiative = iDataInt
            } else {
                print("Check [i]nitiative number.  " +
                    "Should be like: new birbman i7 hp15/21 ac13")
                return
            }
        } else {
            print("Can't find [i]nitiative.  " +
                "Should be like: new birbman i7 hp15/21 ac13")
            return
        }
        
        if identifyInputs(input: commands[3], lookFor: "Hp") == true {
            let hpData: String = extractInputs(input: commands[3], identifier: "Hp")
            let hpDataSeparated: [String] = hpData.components(separatedBy: "/")
            
            if let hpDataInt: Int = Int(hpDataSeparated[0]) {
                hp = hpDataInt
            } else {
                print("Check [hp] number.  " +
                    "Should be like: new birbman i7 hp15/21 ac13")
                return
            }
            
            if let maxHPDataInt: Int = Int(hpDataSeparated[1]) {
                maxHP = maxHPDataInt
            } else {
                print("Check [hp] number.  " +
                    "Should be like: new birbman i7 hp15/21 ac13")
                return
            }
        } else {
            print("Can't find [hp].  " +
                "Should be like: new birbman i7 hp15/21 ac13")
            return
        }
        
        if identifyInputs(input: commands[4], lookFor: "Ac") == true {
            let acData: String = extractInputs(input: commands[4], identifier: "Ac")
            if let acDataInt: Int = Int(acData) {
                ac = acDataInt
            } else {
                print("Check [ac] number.  " +
                    "Should be like: new birbman i7 hp15/21 ac13")
                return
            }
        } else {
            print("Can't find [ac].  " +
                "Should be like: new birbman i7 hp15/21 ac13")
            return
        }
        
        
        if charOrder.count > 0 {
            for i in 0..<charOrder.count {
                //  check initiative, is there already dex?
            }
        } else {
            charOrder.append([charName: Characters(name: charName, ini: initiative, HP: hp, maxHP: maxHP, AC: ac)])
        }

    }
    
    
    switch commands[0] {
    case "Help":
        print(
            """
            new birbman i7 hp15/21 ac13 | new [Name] i[Initiative], hp[HP]/[maxHP], ac[AC]
            birbman hp +8               | adds 8 HP
            birbman hp -7               | removes 7 HP
            birbman status [status]     | adds [status]
            birbman remove [status]     | removes [status]
            birbman leave               | Birbman leaves battle order
            birbman back                | Birbman returns to battle order
            birbman info                | shows all Birbman's info
            birbman log                 | shows history of Birbman's actions
            next                        | next turn
            game                        | print game summary
            exit                        | exit
            """)
    case "New":
        new(inputs: commands)
    case "N":
        //
    case "Game":
        //
    case "Exit":
        //
    default:
        // find character
    }
    
    /*
     split out first word
     if a command, then search next words
     if not, search for character name
     if not found, return
     */
}
