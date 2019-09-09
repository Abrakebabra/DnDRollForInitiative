//
//  commands.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/09.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation


//  New character
func new(command: [String]) {
    
    let charName: String = command[1]
    let initiative: Int
    let hp: Int
    let maximumHP: Int
    let ac: Int
    
    
    if identifyInputs(input: command[2], lookFor: "I") == true {
        let iData: String = extractInputs(input: command[2], identifier: "I")
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
    
    if identifyInputs(input: command[3], lookFor: "Hp") == true {
        let hpData: String = extractInputs(input: command[3], identifier: "Hp")
        let hpDataSeparated: [String] = hpData.components(separatedBy: "/")
        
        if let hpDataInt: Int = Int(hpDataSeparated[0]) {
            hp = hpDataInt
        } else {
            print("Check [hp] number.  " +
                "Should be like: new birbman i7 hp15/21 ac13")
            return
        }
        
        if let maxHPDataInt: Int = Int(hpDataSeparated[1]) {
            maximumHP = maxHPDataInt
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
    
    if identifyInputs(input: command[4], lookFor: "Ac") == true {
        let acData: String = extractInputs(input: command[4], identifier: "Ac")
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
    
    
    if charsOrdered.count > 0 {
        let sameInitChars: [Characters] = sameInitiativeCheck(testInit: initiative)
        
        labelBattleTurnOrders()
        //  labelBattleOrders() Gives every existing character an
        //  array element ID as array position reference to insert new character
        
        
        if sameInitChars.count > 0 {
            //  sameInitChars.count > 0 == true:
            //  Check dex and find all characters with same dex
            
            let dexInput = inputDex(char: charName)
            let sameDexChars: [Characters] = sameDexCheck(initCharList: sameInitChars,
                                                          testDex: dexInput)
            
            if sameDexChars.count > 0 {
                //  sameDexChars.count > 0 == true:
                //  insert in position of choice among same Dex characters
                sameDexInsert(sameDexCharList: sameDexChars, newName: charName,
                              newInit: initiative, newHP: hp, newMaxHP: maximumHP,
                              newAC: ac, newDex: dexInput)
                
            } else {
                //  sameDexChars.count > 0 == false:
                //  insert character at point based on Initiative and Dex
                sameInitInsert(sameInitCharList: sameInitChars, newName: charName,
                               newInit: initiative, newHP: hp, newMaxHP: maximumHP,
                               newAC: ac, newDex: dexInput)
            }
            
        } else {
            //  sameInitChars.count > 0 == false:
            //  insert character at point based on Initiative only
            rollForInitiative(newName: charName, newInit: initiative,
                              newHP: hp, newMaxHP: maximumHP, newAC: ac)
        }
    } else {
        //  charsOrdered.count > 0 == false:
        //  Insert first character
        charsOrdered.append(Characters(name: charName,ini: initiative,
                                       HP: hp, maxHP: maximumHP, AC: ac))
    }
    
}
