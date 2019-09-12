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
    let cmds = command
    let characterName: String = cmds[0]
    let characterIndex: Int = findCharInArray(characterName: characterName)
    var firstInput: String = ""
    var secondInput: String = ""
    
    
    //  If character not found, notify and exit
    if characterIndex == -1 {
        print("Character not found!")
        return
    }
    
    //  If there is a 3rd command, assign it as the action input
    //  If there are more, cancel the function and notify format is incorrect
    if cmds.count == 2 {
        firstInput = cmds[1]
    
    //  If the cmds[1] is + or - and cmds[2] is Int, user is trying to mod hp
    } else if cmds.count == 3 {
        firstInput = cmds[1]
        secondInput = cmds[2]
        
        if firstInput == "+" || firstInput == "-" {
            
            if checkStringToInt(string: cmds[2]) == true {
                firstInput = cmds[1] + cmds[2]
            }
        }
    
    //  If not 2 or 3 commands, format won't match input requirements
    } else {
        print("Check format.  Should be like:\n" +
            "    birbman -7  |  birbman bananas  |  birbman remove bananas")
        return
    }
    
    
    switch firstInput {
    case "Remove":
        charsOrdered[characterIndex].removeStatus(stat: secondInput)
    case "Out":
        charsOrdered[characterIndex].inBattle(trueFalse: false)
    case "In":
        charsOrdered[characterIndex].inBattle(trueFalse: true)
    case "Info":
        charInfo(charIndex: characterIndex)
    case "Log":
        charLog(charIndex: characterIndex)
    default:
        
        //  If only a number after charName, identified as HP change
        if let commandInt: Int = Int(firstInput) {
            charsOrdered[characterIndex].modHitPoints(mod: commandInt)
            displayCharacterList(orderList: currentOrder, showTurns: true)
            
            //  If only single word after charName, identified as status to add
        } else {
            let commandStr: String = String(firstInput)
            charsOrdered[characterIndex].addStatus(stat: commandStr)
        }
    }
    
}
