//
//  generalTools.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/09.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation


//  Seek confirmation
func confirm() -> Bool {
    var awaitingInput: Bool = true
    
    while awaitingInput == true {
        let input: String? = readLine()
        
        if input == "y" {
            awaitingInput = false
            return true
        } else if input == "n" {
            awaitingInput = false
            return false
        }
    }
}


//  Directly input an integer
func inputInt() -> Int {
    var awaitingInput: Bool = true
    
    while awaitingInput == true {
        let input: String? = readLine()
        if let inputStr: String = input, let inputInt: Int = Int(inputStr) {
            awaitingInput = false
            return inputInt
        } else {
            print("Needs a number")
        }
    }
}


//  Find where the character is in the array
func findCharInArray(characterName: String) -> Int {
    for i in 0..<charsOrdered.count {
        if charsOrdered[i].charName == characterName {
            return i
        }
    }
    return -1
}


func printLastChange(characterName: String) {
    let charIndex: Int = findCharInArray(characterName: characterName)
    
    if charIndex == -1 {
        return
    }
    
    if let lastEntry: String = charsOrdered[charIndex].changeLog.last {
        print(lastEntry)
    }
}


//  Identify inputs
func identifyInputs(input: String, lookFor: String) -> Bool {
    let startIndex = input.index(input.startIndex, offsetBy: 0)
    let endIndex = input.index(input.startIndex, offsetBy: lookFor.count)
    let identifier: String = String(input[startIndex..<endIndex])
    
    if lookFor == identifier {
        return true
    } else {
        print("Need to know what each number is for")
        return false
    }
}


//  Extract inputs from commands entered
func extractInputs(input: String, identifier: String) -> String {
    let startIndex = input.index(input.startIndex, offsetBy: identifier.count)
    let endIndex = input.index(input.endIndex, offsetBy: 0)
    let extracted: String = String(input[startIndex..<endIndex])
    
    return extracted
}


func displayCurrentTurn() {
    print("--------------------------------------------------")
    let turnMarker: String = ">>--->  "
    let removedMarker: String = "x_x "
    
    for i in 0..<currentOrder.count {
        let charObj = currentOrder[i]
        let charNamePadded = charObj.charName.padding(toLength: 16, withPad: " ", startingAt: 0)
        
        //  Is in battle and is current turn
        if i == turn {

            if charObj.statuses.count > 0 {
                print("\(turnMarker)" + "\(charNamePadded.uppercased())" +
                    "    HP: \(charObj.hitPoints)/\(charObj.maxHitPoints)" +
                    "    AC: \(charObj.armorClass)" +
                    "    Statuses: \(charObj.statuses)")
            } else {
                print("\(turnMarker)" + "\(charNamePadded.uppercased())" +
                    "    HP: \(charObj.hitPoints)/\(charObj.maxHitPoints)" +
                    "    AC: \(charObj.armorClass)")
            }
            
        } else {
            //  In battle and not in turn
            if currentOrder[i].participating == true {
                
                if charObj.statuses.count > 0 {
                    print("\(charNamePadded)" +
                        "    HP: \(charObj.hitPoints)/\(charObj.maxHitPoints)" +
                        "    AC: \(charObj.armorClass)" +
                        "    Statuses: \(charObj.statuses)")
                } else {
                    print("\(charNamePadded)" +
                        "    HP: \(charObj.hitPoints)/\(charObj.maxHitPoints)" +
                        "    AC: \(charObj.armorClass)")
                }
                
            } else {
                //  Is not in battle and not in turn
                if charObj.statuses.count > 0 {
                    print("\(removedMarker)" + "\(charNamePadded.lowercased())" +
                        "    HP: \(charObj.hitPoints)/\(charObj.maxHitPoints)" +
                        "    AC: \(charObj.armorClass)" +
                        "    Statuses: \(charObj.statuses)")
                } else {
                    print("\(removedMarker)" + "\(charNamePadded.lowercased())" +
                        "    HP: \(charObj.hitPoints)/\(charObj.maxHitPoints)" +
                        "    AC: \(charObj.armorClass)")
                }
            }
            
        }
        //  characters out of battle will never be in turn due to
        //  conditions of next() function
    }
    print("--------------------------------------------------")
}
