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
    var turnMarker: String = ""
    var removedMarker: String = ""
    
    for i in 0..<currentOrder.count {
        
        if i == turn {
            turnMarker = ">>--->  "
        }
        
        if currentOrder[i].participating == false {
            removedMarker = "  X_X  "
        }
        print(turnMarker + removedMarker + currentOrder[i].charName)
    }
}
