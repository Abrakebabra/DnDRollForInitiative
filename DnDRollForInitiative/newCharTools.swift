//
//  newCharTools.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/09.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation


//  Detect the start index 4 stat inputs and whether they are valid integers
func detectStats(cmds: [String]) -> Int {
    
    if cmds.count < 6 {
        return -1
    }
    
    let indexIN: Int = cmds.endIndex - 4
    let indexHP: Int = cmds.endIndex - 3
    let indexHPMax: Int = cmds.endIndex - 2
    let indexAC: Int = cmds.endIndex - 1
    
    if Int(cmds[indexIN]) != nil &&
        Int(cmds[indexHP]) != nil &&
        Int(cmds[indexHPMax]) != nil &&
        Int(cmds[indexAC]) != nil {
        
        //  Returns the start of where the stats start
        return indexIN
        
    } else {
            return -1
    }
}


func concatName(array cmds: [String], until stats: Int) -> String {
    var nameConcat: String = ""
    
    //  format:  new birbman IN HP MAX AC, so 1 is start of name
    for i in 1..<stats {
        if i == 1 {
            nameConcat += cmds[i]
            
        } else {
            nameConcat += " \(cmds[i])"
        }
    }
    
    return nameConcat
}



func sameNameCheck(check: String) -> Bool {
    
    for charObj in charsOrdered {
        
        if charObj.charName == check {
            return true
        }
    }
    return false
}


//  Iterate through all characters and label the order they will appear
func labelBattleTurnOrders() {
    for i in 0..<charsOrdered.count {
        charsOrdered[i].order = Int(i)
    }
}


//  Input a dex number and output an integer to be used by the current
func inputDex(char: String) -> Int {
    var awaitingDex = true
    
    while awaitingDex == true {
        print("What is \(char)'s dexterity:")
        let dexInput = inputInt()
        print("\(char)'s Dex \(dexInput)?\ny / n")
        if confirm() == true {
            awaitingDex = false
            return dexInput
        }
    }
}


/*
 Does the character have a dex number to compare with?
 This should only be called the first instance each initiative roll has a duplicate
 */
func hasDexCheck(char: Characters) -> Bool {
    if char.dexterity != nil {
        return true
    } else {
        return false
    }
}


//  Output an array of all characters with the same initiative roll
func sameInitiativeCheck(testInit: Int) -> [Characters] {
    var sameInitChars: [Characters] = []
    
    for otherChar in charsOrdered {
        
        if otherChar.initiative == testInit {
            
            if hasDexCheck(char: otherChar) == false {
                let dexInput: Int = inputDex(char: otherChar.charName)
                otherChar.dexterity = dexInput
            }
            
            //  Returns a list of existing ordered chars with dex
            sameInitChars.append(otherChar)
        }
    }
    return sameInitChars
}


//  Output an array of all characters with the same initiative roll and dex
func sameDexCheck(initCharList: [Characters], testDex: Int) -> [Characters] {
    let sameInitChars: [Characters] = initCharList
    var sameDexChars:  [Characters] = []
    
    for otherChars in sameInitChars {
        if otherChars.dexterity == testDex {
            sameDexChars.append(otherChars)
        }
    }
    return sameDexChars
}


func showCharEntered(name: String) {
    displayCharacterList(orderList: charsOrdered, showTurns: false)
    let index: Int = findCharInArray(characterName: name)
    charInfo(charIndex: index)
}


func sameDexInsert(sameDexCharList: [Characters], newName: String, newInit: Int, newHP:
    Int, newMaxHP: Int, newAC: Int, newDex: Int) {
    
    var inputAccepted: Bool = false
    let firstIndex: Int = sameDexCharList[0].order!
    let lastIndex: Int = sameDexCharList.last!.order!
    /*
     Force unwrap:  This function is only called if sameDexCharList.count > 0
     and after labelBattleOrders() has been called.
     */
    
    while inputAccepted == false {
        print("Where do you want to insert \(newName)?")
        print("First\n---")
        
        print("[\(firstIndex)]")
        for otherChars in sameDexCharList {
            
            if let otherCharOrder: Int = otherChars.order {
                print("\(otherChars.charName)")
                print("[\(otherCharOrder + 1)]")
            }
        }
        
        print("---\nLast")
        print("Enter [#] position:")
        
        let orderInput: Int = inputInt()
        if orderInput >= firstIndex && orderInput <= lastIndex + 1{
            charsOrdered.insert(Characters(name: newName, ini: newInit, HP: newHP, maxHP: newMaxHP, AC: newAC), at: orderInput)
            charsOrdered[orderInput].dexterity = newDex
            showCharEntered(name: newName)
            inputAccepted = true
        }
    }
}


func sameInitInsert(sameInitCharList: [Characters], newName: String, newInit: Int, newHP:
    Int, newMaxHP: Int, newAC: Int, newDex: Int) {
    
    var turnPos: Int = sameInitCharList[0].order!
    
    for i in 0..<sameInitCharList.count {
        
        if sameInitCharList[i].dexterity! < newDex {
            turnPos = sameInitCharList[i].order!
            
            charsOrdered.insert(Characters(name: newName, ini: newInit, HP: newHP, maxHP: newMaxHP, AC: newAC), at: turnPos)
            charsOrdered[turnPos].dexterity = newDex
            showCharEntered(name: newName)
            return
        }
    }
    
    charsOrdered.insert(Characters(name: newName, ini: newInit, HP: newHP, maxHP: newMaxHP, AC: newAC), at: turnPos + 1)
    charsOrdered[turnPos].dexterity = newDex
    showCharEntered(name: newName)
    
}


func rollForInitiative(newName: String, newInit: Int, newHP:
    Int, newMaxHP: Int, newAC: Int) {
    
    var turnPos: Int = charsOrdered[0].order!
    
    for i in 0..<charsOrdered.count {
        
        if charsOrdered[i].initiative < newInit {
            turnPos = charsOrdered[i].order!
            
            charsOrdered.insert(Characters(name: newName, ini: newInit, HP: newHP, maxHP: newMaxHP, AC: newAC), at: turnPos)
            showCharEntered(name: newName)
            return
        }
    }
    
    charsOrdered.insert(Characters(name: newName, ini: newInit, HP: newHP, maxHP: newMaxHP, AC: newAC), at: turnPos + 1)
    showCharEntered(name: newName)
}
