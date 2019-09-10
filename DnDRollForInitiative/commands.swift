//
//  commands.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/09.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation


func help() {
    print("---------------- Help ----------------")
    print(
        """
        new birbman i7 hp15/21 ac13 | new [Name] i[Initiative], hp[HP]/[maxHP], ac[AC]
        birbman hp +8               | adds 8 HP
        birbman hp -7               | removes 7 HP
        birbman status [status]     | adds [status]
        birbman remove [status]     | removes [status]
        birbman out                 | Birbman leaves battle order
        birbman in                  | Birbman returns to battle order
        birbman info                | shows all Birbman's info
        birbman log                 | shows history of Birbman's actions
        next                        | next turn
        game                        | print game summary
        exit                        | exit
        """)
    print("---------------- Help end ----------------")
}


//  New character
func new(command: [String]) {
    
    let charName: String = command[1]
    let initiative: Int
    let hp: Int
    let maximumHP: Int
    let ac: Int
    
    if sameNameCheck(check: charName) == true {
        print("Same name already entered!")
        return
    }
    
    //  Perhaps prompts might be better than writing out a string of text
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



/*
 Perhaps a slow prompted add, and a quick single line add

 For example:
 [Name] [Initiative] [HP/MAX] [AC]
 
 please enter in format of:  name 15 18/18 12
 
 */




func next() {
    var availableCharFound: Bool = false
    
    func availableCharsRemaining() -> Bool {
        var availableChars: Int = 0
        
        for i in 0..<charsOrdered.count {
            if charsOrdered[i].participating == true {
                availableChars += 1
            }
        }
        
        if availableChars > 1 {
            return true
        } else {
            return false
        }
    }
    
    func nextTurn() {
        turn += 1
        
        if turn > currentOrder.count - 1 {
            currentOrder = charsOrdered
            turn = 0
        }
    }
    
    func availabilityCheck() -> Bool {
        if charsOrdered[turn].participating == true {
            return true
        } else {
            return false
        }
    }
    
    //  If there are less than 2 available characters left, next turn functions
    //  will not be called
    if availableCharsRemaining() == true {
        
        while availableCharFound == false {
            nextTurn()
            availableCharFound = availabilityCheck()
        }
        
        displayCurrentTurn()
        
    } else {
        print("No other available characters to change turn to")
        return
    }
    
}


func game() {
    print("============ GAME SUMMARY ============")
    for event in gameLog {
        print(event)
    }
    print("======================================")
}


func exit() {
    print("Are you sure you want to exit?  y/n")
    let confirm1 = confirm()
    if confirm1 == true {
        print("Double sure?  y/n")
        let confirm2 = confirm()
        if confirm2 == true {
            runProgram = false
        }
    }
}


func characterCommands(command: [String]) -> Void {
    /*
     Commands:
     birbman hp +8               | adds 8 HP
     birbman hp -7               | removes 7 HP
     birbman status [status]     | adds [status]
     birbman remove [status]     | removes [status]
     birbman out                 | Birbman leaves battle order
     birbman in                  | Birbman returns to battle order
     birbman info                | shows all Birbman's info
     birbman log                 | shows history of Birbman's actions
    */
    let characterName: String = command[0]
    let characterIndex: Int = findCharInArray(characterName: characterName)
    var actionInput: String = ""
    
   
    //  If character not found, notify and exit
    if characterIndex == -1 {
        print("Character not found!")
        return
    }
    
    //  If there is a 3rd command, assign it as the action input
    //  If there are more, cancel the function and notify format is incorrect
    if command.count > 2 {
        actionInput = command[2]
    } else if command.count > 3 {
        print("Check format.  Should be like:\n" +
            "    birbman hp -7 or birbman status bananas")
        return
    }
    
    switch command[1] {
    case "Hp":
        charHp(charIndex: characterIndex, modifier: actionInput)
    case "Status":
        charsOrdered[characterIndex].addStatus(stat: actionInput)
    case "Remove":
        charsOrdered[characterIndex].removeStatus(stat: actionInput)
    case "Out":
        charsOrdered[characterIndex].inBattle(trueFalse: false)
    case "In":
        charsOrdered[characterIndex].inBattle(trueFalse: true)
    case "Info":
        charInfo(charIndex: characterIndex)
    case "Log":
        charLog(charIndex: characterIndex)
    default:
        print("Check format.  Should be like:\n" +
            "    birbman hp -7    or    birbman status bananas")
        return
    }
    
    
}
