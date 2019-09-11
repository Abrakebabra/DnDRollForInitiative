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
    
    
    //  add option for multiple enemies of the same kind with varying hp
    switch commands[0] {
    case "Help":
        help()
    case "New":
        new(command: commands)
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
        characterCommands(command: commands)
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
