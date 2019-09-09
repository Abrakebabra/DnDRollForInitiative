//
//  newCharTools.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/09.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation


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


//  Input a dex number and output an integer to be used by the current
func inputDex(char: String) -> Int {
    var awaitingDex = true
    
    while awaitingDex == true {
        print("What is \(char)'s dexterity:")
        let dexInput = inputInt()
        print("\(char) dexterity: [\(dexInput)] ok?")
        if confirm() == true {
            awaitingDex = false
            return dexInput
        }
    }
}


//  Output an array of all characters with the same initiative roll
func sameInitiativeCheck(testInit: Int) -> [Characters] {
    var sameInitChars: [Characters] = []
    
    for otherChars in charsOrdered {
        
        if otherChars.initiative == testInit {
            
            if hasDexCheck(char: otherChars) == false {
                let dexInput: Int = inputDex(char: otherChars.charName)
                otherChars.dexterity = dexInput
            }
            
            sameInitChars.append(otherChars)
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
