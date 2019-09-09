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
        print(
            """
            new birbman i7 hp15/21 ac13 | new [Name] i[Initiative], hp[HP]/[maxHP], ac[AC]
            birbman hp +8               | adds 8 HP
            birbman hp -7               | removes 7 HP
            birbman status [status]     | adds [status]
            birbman remove [status]     | removes [status]
            birbman out                 | Birbman leaves battle order
            birbman in                  | Birbman returns to battle order
            birbman info                | shows all Birbman's info
            birbman log                 | shows history of Birbman's actions
            next                        | next turn
            game                        | print game summary
            exit                        | exit
            """)
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
        characterModify(command: commands)
    }
    
    /*
     split out first word
     if a command, then search next words
     if not, search for character name
     if not found, return
     */
}
