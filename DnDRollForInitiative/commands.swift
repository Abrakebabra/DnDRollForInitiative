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
        new birbman 7 15 21 13      |  new [Name] [Initiative] [HP] [maxHP] [AC]
        birbman 8                   |  adds 8 HP
        birbman -7                  |  removes 7 HP
        birbman [status]            |  adds [status]
        birbman remove [status]     |  removes [status]
        birbman out                 |  Birbman leaves battle order
        birbman in                  |  Birbman returns to battle order
        birbman info                |  shows all Birbman's info
        birbman log                 |  shows history of Birbman's actions
        next                        |  next turn
        d                           |  re-displays current turn and info
        chars                       |  displays list of all entered characters
        game                        |  print game summary
        exit                        |  exit
        """)
    print("---------------- Help end ----------------")
}


//  New character
func new(command: [String]) {
    
    /*
        Direct entry
        new birbman 9 28 28 13
        - command.count == 6
        - var entryOK = false and changed to true when all conditions met
        - command[2] can be turned into an integer
        - command[3] can be turned into an integer
        - command[4] can be turned into an integer
        - command[5] can be turned into an integer
        - checks all conditions are met
        - shows confirmation of character stats
    */
    
    // Check that there are 6 commands
    if command.count != 6 {
        print("Should be like: new birbman 9 28 28 13")
        return
    }
    
    let charName: String = command[1]
    
    if sameNameCheck(check: charName) == true {
        print("Same name already entered!")
        return
    }
    
    guard let initiative: Int = Int(command[2]),
        let hp: Int = Int(command[3]),
        let maximumHP: Int = Int(command[4]),
        let ac: Int = Int(command[5])
        
    else {
        print("new [name] [initiative] [hp] [max] [ac]\n" +
            "Command not recognized.\nShould be like: new birbman 9 28 28 13")
        return
    }
    
    let initStat: String = "IN " + String(initiative)
    let hpStat: String = "HP " + String(hp) + "/" + String(maximumHP)
    let acStat: String = "AC " + String(ac)
    
    print("\(charName)   \(initStat)   \(hpStat)   \(acStat)   OK?\ny / n")
    
    if confirm() == false {
        print("New character cancelled")
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
        showCharEntered(name: charName)
    }
    
}


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
        
        displayCharacterList(orderList: currentOrder, showTurns: true)
        
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
    print("Are you sure you want to exit?\ny / n")
    if confirm() == true {
        runProgram = false
        game()
    }
}
