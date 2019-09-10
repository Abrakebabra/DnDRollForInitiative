//
//  main.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/04.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation

//  add names, initiative, hitpoints, AC
//  If multiple initiative rolls are the same, then add dex
//  If dex is same, then give choice
//  Way to add new characters halfway through battle (if initiative is same, goes through same handling process if clashes with another character)
//  Way to temporarily/permanently remove characters from battle
//  Way to instantly remove/add hitpoints to/from any character
//  Status effects (text next to names such as concentration, frightened, poisoned - just add Kelsey's custom text next to name)
//  Option to show all characters, stats (and initiative?)  Need to know for status effects
//  [current character turns] [next set character turns, new characters introduced here]



//  help = show available commands
//  all = show all characters, order, stats,
//  add = new characters (and check)

/*
 Turn order:
 -----------
 
 */

//  Consider adding max HP?  Might take away from the game if entering too much info

var gameLog: [String] = []

var charsOrdered: [Characters] = []
var currentOrder: [Characters] = []  //  Copies order when finished all turns
var turn: Int = 0

var runProgram: Bool = true

while runProgram == true {
    let rawInput: String? = readLine()
    if let stringInput: String = rawInput {
        inputToCommands(input: stringInput)
    }
}

print("Fin.")
