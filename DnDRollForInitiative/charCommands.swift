//
//  charCommands.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/09.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation


func charInfo(charIndex: Int) {
    let charObj: Characters = charsOrdered[charIndex]
    let charName: String = charObj.charName
    let participating: Bool = charObj.participating
    let initiative: Int = charObj.initiative
    let hp: Int = charObj.hitPoints
    let maxHP: Int = charObj.maxHitPoints
    let armorClass: Int = charObj.armorClass
    let statuses: [String] = charObj.statuses
    
    print("------------ \(charName.uppercased()) ------------")
    if participating == true {
        print("IN BATTLE")
    } else {
        print("OUT OF ACTION")
    }
    print("Hit Points".padding(toLength: 18, withPad: " ", startingAt: 0) +
        "\(hp)/\(maxHP)")
    print("Armor Class".padding(toLength: 18, withPad: " ", startingAt: 0) +
        "\(armorClass)")
    if statuses.count > 0 {
        print("Status Effects".padding(toLength: 18, withPad: " ", startingAt: 0) +
            "\(statuses)")
    }
    print("Initiative".padding(toLength: 18, withPad: " ", startingAt: 0) +
        "\(initiative)")
    if let dexterity: Int = charObj.dexterity {
        print("Dexterity".padding(toLength: 18, withPad: " ", startingAt: 0) +
            "\(dexterity)")
    }
    
    print("------------ \(charName.lowercased()) ------------")
}


func charLog(charIndex: Int) {
    let charName: String = charsOrdered[charIndex].charName
    print("------------ \(charName.uppercased())'s Change Log ------------")
    for change in charsOrdered[charIndex].changeLog {
        print(change)
    }
    print("------------ End of \(charName.uppercased())'s Changes ------------")
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
    
    var characterName: String = ""
    
    if command.count < 1 {
        print("No command identified")
        return
    }
    
    
    let cmdLastElementIndex: Int = command.endIndex - 1
    var cmdLast: String = command[cmdLastElementIndex]
    
    
    if command.count < 2 {
        characterName = command[0]
        let characterIndex: Int = findCharInArray(characterName: characterName)
        if characterIndex == -1 {
            print("\(characterName) not found!")
            return
        }
        charInfo(charIndex: characterIndex)
        return
    }
   
    
    if cmdLast == "Log" {
        characterName = concatName(array: command, from: 0, until: cmdLastElementIndex)
        let characterIndex: Int = findCharInArray(characterName: characterName)
        if characterIndex == -1 {
            print("\(characterName) not found!")
            return
        }
        charLog(charIndex: characterIndex)
        return
        
    } else if cmdLast == "In" {
        characterName = concatName(array: command, from: 0, until: cmdLastElementIndex)
        let characterIndex: Int = findCharInArray(characterName: characterName)
        if characterIndex == -1 {
            print("\(characterName) not found!")
            return
        }
        charsOrdered[characterIndex].inBattle(trueFalse: true)
        return
        
    } else if cmdLast == "Out" {
        characterName = concatName(array: command, from: 0, until: cmdLastElementIndex)
        let characterIndex: Int = findCharInArray(characterName: characterName)
        if characterIndex == -1 {
            print("\(characterName) not found!")
            return
        }
        charsOrdered[characterIndex].inBattle(trueFalse: false)
        return
    }
    
    
    if let cmdLastInt: Int = Int(cmdLast) {
        let detectPlusMinus: String = cmdLast
        let subIndexStart = detectPlusMinus.index(detectPlusMinus.startIndex, offsetBy: 0)
        let subIndexEnd = detectPlusMinus.index(detectPlusMinus.startIndex, offsetBy: 1)
        let subString = detectPlusMinus[subIndexStart..<subIndexEnd]
        
        if subString == "+" || subString == "-" {
            characterName = concatName(array: command, from: 0, until: cmdLastElementIndex)
            let characterIndex: Int = findCharInArray(characterName: characterName)
            if characterIndex == -1 {
                print("\(characterName) not found!")
                return
            }
            charsOrdered[characterIndex].modHitPoints(mod: cmdLastInt)
            displayCharacterList(orderList: currentOrder, showTurns: true)
            return
        }
        
        if command.count < 3 {
            characterName = concatName(array: command, from: 0, until: command.endIndex)
            let characterIndex: Int = findCharInArray(characterName: characterName)
            if characterIndex == -1 {
                print("\(characterName) not found!")
                return
            }
            charInfo(charIndex: characterIndex)
            return
        }
        
        let cmdSecondLastElementIndex: Int = command.endIndex - 2
        let cmdSecondLast: String = command[cmdSecondLastElementIndex]
        
        if cmdSecondLast == "+" || cmdSecondLast == "-" {
            characterName = concatName(array: command, from: 0, until: cmdSecondLastElementIndex)
            cmdLast = cmdSecondLast + cmdLast
            if let cmdLastConcatInt: Int = Int(cmdLast) {
                let characterIndex: Int = findCharInArray(characterName: characterName)
                if characterIndex == -1 {
                    print("\(characterName) not found!")
                    return
                }
                charsOrdered[characterIndex].modHitPoints(mod: Int(cmdLastConcatInt))
            }
            return
            
        } else {
            characterName = concatName(array: command, from: 0, until: command.endIndex)
            let characterIndex = findCharInArray(characterName: characterName)
            if characterIndex == -1 {
                print("\(characterName) not found!")
                return
            }
            charInfo(charIndex: characterIndex)
            return
        }
    }
    
    
    if command.count < 3 {
        characterName = concatName(array: command, from: 0, until: command.endIndex)
        var characterIndex: Int = findCharInArray(characterName: characterName)
        
        
        if characterIndex != -1 {
            charInfo(charIndex: characterIndex)
            return
            
        } else {
            characterName = concatName(array: command, from: 0, until: cmdLastElementIndex)
            characterIndex = findCharInArray(characterName: characterName)
            if characterIndex == -1 {
                print("\(characterName) not found!")
                return
            }
            charsOrdered[characterIndex].addStatus(stat: cmdLast)
            return
        }
    }
    
    
    let cmdSecondLastElementIndex: Int = command.endIndex - 2
    let cmdSecondLast: String = command[cmdSecondLastElementIndex]
    
    if cmdSecondLast == "Remove" {
        characterName = concatName(array: command, from: 0, until: cmdSecondLastElementIndex)
        let characterIndex = findCharInArray(characterName: characterName)
        if characterIndex == -1 {
            print("\(characterName) not found!")
            return
        }
        charsOrdered[characterIndex].removeStatus(stat: cmdLast)
        return
    }
    
    
    characterName = concatName(array: command, from: 0, until: command.endIndex)
    var characterIndex: Int = findCharInArray(characterName: characterName)
    
    if characterIndex != -1 {
        charInfo(charIndex: characterIndex)
        return
        
    } else {
        characterName = concatName(array: command, from: 0, until: cmdLastElementIndex)
        characterIndex = findCharInArray(characterName: characterName)
        if characterIndex == -1 {
            print("\(characterName) not found!")
            return
        }
        charsOrdered[characterIndex].addStatus(stat: cmdLast)
    }
    

}
