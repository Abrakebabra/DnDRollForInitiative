//
//  notes.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/11.
//  Copyright © 2019 Keith Lee. All rights reserved.
//





/*

PRIORITY:
* Has to be easier and more convenient than using pen and paper for battles with large numbers of characters

General mechanics:
- add names, initiative, hitpoints, AC
- If multiple initiative rolls are the same, then add dex
- If dex is same, then give choice
- Way to add new characters halfway through battle (if initiative is same, goes through same handling process if clashes with another character)
- Way to temporarily/permanently remove characters from battle
- Way to instantly remove/add hitpoints to/from any character
- Status effects (text next to names such as concentration, frightened, poisoned - just add Kelsey's custom text next to name)
Option to show all characters, stats (and initiative?)  Need to know for status effects
[current character turns] [next set character turns, new characters introduced here]


 
 
 Bugs:
 - if enter a name and no other commands after, program crashes
 - if enter new name and no other commands program crashes
 
 
 To re-design/modify:
 - output printlines not so great to read
 - new character entry is confusing to use.  Prompts might be better
 - add option for quick entry without prompts
 - perhaps a while loop to enter them all without needing to type "new" then exit
 that loop when "end" is typed.
 
 - after modifying, should display everything again with updated stats
 - making changes such as HP, needs a change confirmed printline
 - are all the confirmations necessary?
 - option to delete a character entirely if mistakes are made?
 - or option to modify its stats directly?
 - If y/n for confirmation not entered, needs to re-show the confirmation prompt
 otherwise I don't know whether my input has been received or it's still waiting
 DONE the display of turns and info doesn't look great.  Confusing and messy
 - need to sit down and design how all text is displayed so it is consistent across all
 screens and printouts
 - for character info, use padding instead of spaces.
 - perhaps AC should be higher up and initiative
 
 
 - perhaps for hp, just name and number like birbman 8 or birbman +9
 - can be done, just add to default, and check that number can be turned into integer
 and if not, report back that the command doesn't work.
 
 To clean:
 
 
 To do:
 - Write a list of every possible action and situation to test
 
 

 
 Frog            HP: 21/21    AC: 7
 CAT                     HP: 21/21    AC: 8
 Bird
 
 
 or perhaps count how many characters the longest name is and add that for padding
 Probably cleanest
 */
