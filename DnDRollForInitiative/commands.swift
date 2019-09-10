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
    
    let namePad = charName.padding(toLength: 16, withPad: " ", startingAt: 0)
    let hpStat: String = "HP " + String(hp) + "/" + String(maximumHP)
    let hpPad: String = hpStat.padding(toLength: 12, withPad: " ", startingAt: 0)
    let acStat: String = "AC " + String(ac)
    
    print("\(namePad)\(hpPad)\(acStat)\nIs this ok?  y/n")
    
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
        printLastChange(characterName: charName)
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
    if confirm() == true {
        runProgram = false
        game()
    }
}


func characterCommands(command: [String]) -> Void {
    /*
     Commands:
     birbman 8                   | adds 8 HP
     birbman -7                  | removes 7 HP
     birbman [status]            | adds [status]
     birbman remove [status]     | removes [status]
     birbman out                 | Birbman leaves battle order
     birbman in                  | Birbman returns to battle order
     birbman info                | shows all Birbman's info
     birbman log                 | shows history of Birbman's actions
    */
    let characterName: String = command[0]
    let characterIndex: Int = findCharInArray(characterName: characterName)
    var action: String = ""
    var actionInput: String = ""
    
   
    //  If character not found, notify and exit
    if characterIndex == -1 {
        print("Character not found!")
        return
    }
    
    //  If there is a 3rd command, assign it as the action input
    //  If there are more, cancel the function and notify format is incorrect
    if command.count < 2 {
        print("Check format.  Should be like:\n" +
            "    birbman hp -7 or birbman status bananas")
        return
    } else {
        action = command[1]
    }
    
    if command.count > 2 {
        actionInput = command[2]
    } else if command.count > 3 {
        print("Check format.  Should be like:\n" +
            "    birbman hp -7 or birbman status bananas")
        return
    }
    
    switch action {
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
        /*
          - command.count == 2
         
         Mod HP:
          - command[1] can be converted to integer, else add status
         
         Add status:
          - command[1] cannot be converted to integer
         */
        return
    }
    
    
}
