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
    
    
    //  add option for multiple enemies of the same kind with varying hp
    switch commands[0] {
    case "Help":
        help()
    case "New":
        new(command: commands)
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
    
    /*
     split out first word
     if a command, then search next words
     if not, search for character name
     if not found, return
     */
}
