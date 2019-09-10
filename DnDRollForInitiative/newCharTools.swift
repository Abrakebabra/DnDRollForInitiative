//
//  newCharTools.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/09.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation


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
        print("\(char)'s Dex [\(dexInput)] ok?  y/n")
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
            printLastChange(characterName: newName)
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
            printLastChange(characterName: newName)
            return
        }
    }
    
    charsOrdered.insert(Characters(name: newName, ini: newInit, HP: newHP, maxHP: newMaxHP, AC: newAC), at: turnPos + 1)
    charsOrdered[turnPos].dexterity = newDex
    printLastChange(characterName: newName)
    
}


func rollForInitiative(newName: String, newInit: Int, newHP:
    Int, newMaxHP: Int, newAC: Int) {
    
    var turnPos: Int = charsOrdered[0].order!
    
    for i in 0..<charsOrdered.count {
        
        if charsOrdered[i].initiative < newInit {
            turnPos = charsOrdered[i].order!
            
            charsOrdered.insert(Characters(name: newName, ini: newInit, HP: newHP, maxHP: newMaxHP, AC: newAC), at: turnPos)
            printLastChange(characterName: newName)
            return
        }
    }
    
    charsOrdered.insert(Characters(name: newName, ini: newInit, HP: newHP, maxHP: newMaxHP, AC: newAC), at: turnPos + 1)
    printLastChange(characterName: newName)
}
