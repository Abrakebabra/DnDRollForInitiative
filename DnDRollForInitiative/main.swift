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
    var dexterityMod: Int?  //  can this change halfway through a battle?
    var hitPoints: Int
    var armorClass: Int  //  can this change halfway through a battle?
    var statuses: [String] = []
    var conscious: Bool = true
    var changeLog: [String] = []

    
    init(name: String, ini: Int, HP: Int, AC: Int) {
        charName = name
        initiative = ini
        hitPoints = HP
        armorClass = AC
        changeLog.append("Initialized with Character Name: \(name), Initiative: \(ini), HP: \(HP), AC: \(AC)")
        gameLog.append("\(name) has entered the fight with [\(HP)] HP!")
    }
    
    func sameInitiative(dexMod: Int) {
        print("Dexterity Modifier of [\(dexMod)] for \(charName)?")
        let result = confirm()
        if result == true {
            dexterityMod = dexMod
            changeLog.append("Dexterity Mod added: \(dexMod)")
        }
    }
    
    func addStatus(stat: String) {
        print("Add status effect of [\(stat)] to \(charName)?")
        let result = confirm()
        if result == true {
            statuses.append(stat)
            changeLog.append("Added Status: \(stat)")
            gameLog.append("\(charName) has status effect: [\(stat)]!")
        }
        
    }
    
    func removeStatus(stat: String) {
        guard let index = self.statuses.firstIndex(of: stat) else { return }
        self.statuses.remove(at: index)
        gameLog.append("\(charName) no longer has status effect: [\(stat)]!")
    }
    
    func modHitpoints(mod: String) {
        let cleanString: String = mod.replacingOccurrences(of: " ", with: "")
        
        if let modifier: Int = Int(cleanString) {
            hitPoints += modifier
        }
        
       
    }
    
    func consciousState(trueFalse state: Bool) {
        self.conscious = state
    }
    
}

var order: [[String: Characters]] = []
var currentTurn: [[String: Characters]] = []  //  Copies order when finished all turns
