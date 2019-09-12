//
//  main.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/04.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation


var gameLog: [String] = []

/*
 charsOrdered:
 Stores list of all characters in order.  Unchanging except when char is added or deleted
 
 currentOrder:
 Copies order on first turn or finished all turns
 
 */
var charsOrdered: [Characters] = []
var currentOrder: [Characters] = []
var turn: Int = 0

var runProgram: Bool = true


func inputToCommands(input: String) {
    
    /*
     split out first word
     if a command, then search next words
     if not, search for character name
     if not found, return
     */
    let inputCap: String = input.capitalized
    let commands: [String] = inputCap.components(separatedBy: " ")
    var commandsCleaned: [String] = []
    
    //  Cleans up any accidental spaces to be much more forgiving
    for i in commands {
        if i != "" {
            commandsCleaned.append(i)
        }
    }
    
    //  If only spaces entered, exits the function
    if commandsCleaned.count < 1 {
        return
    }
    
    //  add option for multiple enemies of the same kind with varying hp
    switch commandsCleaned[0] {
    case "Help":
        help()
    case "New":
        new(command: commandsCleaned)
    case "D":
        displayCharacterList(orderList: currentOrder, showTurns: true)
    case "Chars":
        displayCharacterList(orderList: charsOrdered, showTurns: false)
    case "Next":
        next()
    case "Game":
        game()
    case "Exit":
        exit()
    default:
        // find character
        characterCommands(command: commandsCleaned)
    }
    
}


help()

while runProgram == true {
    let rawInput: String? = readLine()
    if let stringInput: String = rawInput {
        inputToCommands(input: stringInput)
    }
}

print("\n\nFin.\n\n")
