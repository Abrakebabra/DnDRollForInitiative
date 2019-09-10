//
//  generalTools.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/09.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation

/*
 GENERAL TOOLS:
  24.  Seek confirmation -> Bool
  42.  Direct integer input -> Int
  58.  Find character in charOrdered array -> Int
  69.  Print character's last changeLog entry -> Void
  83.  Identify command prefix -> Bool                  (MAYBE GET RID OF THIS STEP)
  98.  Extract inputs from command prefix -> String     (MAYBE GET RID OF THIS STEP)
  108. Display current turn and info -> Void
 */


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


//  Print the last entry in the character's changeLog
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


//  Display the current turn and information
func displayCurrentTurn() {
    /*
         Frog            HP 21/21    AC 7    ["Status", "Status"]
     CAT                 HP 21/21    AC 13
         Bird
         Dog             HP 14/15    AC 14   ["Status"]
     
     Not turn, in battle:
      - 4 spaces to left
      - padding to 16
      - hp padding to 12
      - ac padding to 9
     
     turn, in battle:
      - all caps
      - no spaces to left
      - padding to 20
      - hp padding to 12
      - ac padding to 9
     
     out of battle:
      - 4 spaces to left
     
    */
    print("--------------------------------------------------")
    
    
    for i in 0..<currentOrder.count {
        let charName: String = currentOrder[i].charName
        let namePad = charName.padding(toLength: 16, withPad: " ", startingAt: 0)
        
        let hpRaw: String = String(currentOrder[i].hitPoints)
        let maxHPRaw: String = String(currentOrder[i].maxHitPoints)
        let hpStat: String = "HP " + hpRaw + "/" + maxHPRaw
        let hpPad: String = hpStat.padding(toLength: 12, withPad: " ", startingAt: 0)
        
        let acRaw: String = String(currentOrder[i].armorClass)
        let acStat: String = "AC " + acRaw
        let acPad: String = acStat.padding(toLength: 9, withPad: " ", startingAt: 0)
        
        
        //  Is in battle and is current turn
        if i == turn {
            let namePadTurn: String = charName.padding(toLength: 20,
                                                       withPad: " ",
                                                       startingAt: 0)
            if currentOrder[i].statuses.count > 0 {
                print("\(namePadTurn)\(hpPad)\(acPad)" +
                    "\(currentOrder[i].statuses)")
            } else {
                print("\(namePadTurn)\(hpPad)\(acPad)")
            }
            
        } else {
            //  In battle and not in turn
            if currentOrder[i].participating == true {
                
                if currentOrder[i].statuses.count > 0 {
                    print("    " + "\(namePad)\(hpPad)\(acPad)" +
                        "\(currentOrder[i].statuses)")
                } else {
                    print("    " + "\(namePad)\(hpPad)\(acPad)")
                }
                
            } else {
                //  Is not in battle and not in turn
                print("    " + "\(charName)")
            }
            
        }
        //  characters out of battle will never be in turn due to
        //  conditions of next() function
    }
    print("--------------------------------------------------")
}
