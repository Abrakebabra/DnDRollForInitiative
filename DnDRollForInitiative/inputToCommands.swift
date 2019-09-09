//
//  inputToCommands.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/09.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation

func inputToCommands(input: String) {
    
    let inputCap: String = input.capitalized
    let commands: [String] = inputCap.components(separatedBy: " ")
    
    
    func new(inputs: [String]) {
        let charName: String = commands[1]
        let initiative: Int
        let hp: Int
        let maxHP: Int
        let ac: Int
        
        
        if identifyInputs(input: commands[2], lookFor: "I") == true {
            let iData: String = extractInputs(input: commands[2], identifier: "I")
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
        
        if identifyInputs(input: commands[3], lookFor: "Hp") == true {
            let hpData: String = extractInputs(input: commands[3], identifier: "Hp")
            let hpDataSeparated: [String] = hpData.components(separatedBy: "/")
            
            if let hpDataInt: Int = Int(hpDataSeparated[0]) {
                hp = hpDataInt
            } else {
                print("Check [hp] number.  " +
                    "Should be like: new birbman i7 hp15/21 ac13")
                return
            }
            
            if let maxHPDataInt: Int = Int(hpDataSeparated[1]) {
                maxHP = maxHPDataInt
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
        
        if identifyInputs(input: commands[4], lookFor: "Ac") == true {
            let acData: String = extractInputs(input: commands[4], identifier: "Ac")
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
            let sameInitChars = sameInitiativeCheck(testInit: initiative)
            
            if sameInitChars.count > 0 {
                let dexInput = inputDex(char: charName)
                let sameDexChars = sameDexCheck(initCharList: sameInitChars, testDex: dexInput)
                
                if sameDexChars.count > 0 {
                    labelBattleOrders()
                    print("Insert at: [num]")
                    print("First\n---")
                    if let topIndex: Int = sameDexChars[0].order {
                        print("[\(topIndex)]")
                    }
                    
                    for otherChars in sameDexChars {
                        
                        if let otherCharOrder: Int = otherChars.order {
                            print("\(otherChars.charName)")
                            print("[\(otherCharOrder + 1)]")
                        }
                    }
                    
                    print("---\nLast")
                    
                    //  insert in position
                } else {
                    // insert character at point based on Initiative and Dex
                }
                
            } else {
                //  insert character at point based on Initiative only
            }
        } else {
            //  Insert first character
            charsOrdered.append(Characters(name: charName, ini: initiative, HP: hp, maxHP: maxHP, AC: ac))
        }
        
    }
    
    
    switch commands[0] {
    case "Help":
        print(
            """
            new birbman i7 hp15/21 ac13 | new [Name] i[Initiative], hp[HP]/[maxHP], ac[AC]
            birbman hp +8               | adds 8 HP
            birbman hp -7               | removes 7 HP
            birbman status [status]     | adds [status]
            birbman remove [status]     | removes [status]
            birbman leave               | Birbman leaves battle order
            birbman back                | Birbman returns to battle order
            birbman info                | shows all Birbman's info
            birbman log                 | shows history of Birbman's actions
            next                        | next turn
            game                        | print game summary
            exit                        | exit
            """)
    case "New":
        new(inputs: commands)
    case "Next":
    //
    case "Game":
    //
    case "Exit":
        print("Are you sure you want to exit?")
        let confirm1 = confirm()
        if confirm1 == true {
            print("Double sure?")
            let confirm2 = confirm()
            if confirm2 == true {
                //  stop run loop
            }
        }
    default:
        // find character
    }
    
    /*
     split out first word
     if a command, then search next words
     if not, search for character name
     if not found, return
     */
}
