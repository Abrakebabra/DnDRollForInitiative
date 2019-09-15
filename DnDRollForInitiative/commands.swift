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
        (characters may have spaces, numbers and symbols)

        birbman                     |  shows all Birbman's info
        birbman +8                  |  adds 8 HP
        birbman -7                  |  removes 7 HP
        birbman [status]            |  adds [status]
        birbman remove [status]     |  removes [status]
        birbman out                 |  Birbman leaves battle order
        birbman in                  |  Birbman returns to battle order
        birbman log                 |  shows history of Birbman's actions
        birbman delete              |  permanently delete Birbman
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
     
     Allows spaces in names.
     banana rama 2 10 20 24 12 - Becomes [Banana Rama 2] [10] [20] [24] [12]
     banana rama 2 10 20 24 - Becomes [Banana Rama] [2] [10] [20] [24]
     banana rama 2 10 hp20/24 ac12 - Rejected
     banana rama 2 10 20 - Rejected
    */
    
    //  5 elements [concatName] [IN] [HP] [MAX] [AC]
    let concatCmds: [String]
    
    //  Check that there are at least 6 inputs
    //  Exit function if less
    if command.count < 6 {
        print("Should be like: new birbman 9 28 28 13")
        return
    
    //  Check that the last 4 elements can be converted to integers
    //  Return the index of the 4th to last element (Initiative stat)
    //  Exit function if failed
    } else {
        let statStart: Int = detectStats(cmds: command)
        
        if statStart == -1 {
            print("Should be like: new birbman 9 28 28 13")
            return
            
        } else {
            //  Concat all elements from first name element to stats
            let nameConcat: String = concatName(array: command, from: 1, until: statStart)
            
            concatCmds = [nameConcat, command[statStart], command[statStart + 1],
            command[statStart + 2], command[statStart + 3]]
        }
    }
    
    
    let charName: String = concatCmds[0]
    
    if sameNameCheck(check: charName) == true {
        print("Same name already entered!")
        return
    }
    
    //  detectStats() already checks for validity
    //  Exits function if fails checks  (statStart == -1)
    let initiative: Int = Int(concatCmds[1])!
    let hp: Int = Int(concatCmds[2])!
    let maximumHP: Int = Int(concatCmds[3])!
    let ac: Int = Int(concatCmds[4])!
    
    
    //  New character confirmation
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
