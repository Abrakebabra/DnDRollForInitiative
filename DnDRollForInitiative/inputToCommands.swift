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
        new(command: commands)
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
