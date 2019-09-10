//
//  notes.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/11.
//  Copyright © 2019 Keith Lee. All rights reserved.
//


/*
 
 
 PRIORITY:
 Has to be easier and more convenient than using pen and paper for battles with large numbers of characters

 
 
 GENERAL MECHANICS:
- Add names, initiative, hitpoints, AC
- If multiple initiative rolls are the same, then add dex
- If dex is same, give choice
- Add new characters halfway through battle (if initiative is same, goes through same handling process if clashes with another character)
- Temporarily/permanently remove characters from battle
- Way to instantly remove/add hitpoints to/from any character
- Status effects (text next to names such as concentration, frightened, poisoned - just add custom text next to name)
- Option to show all characters, stats (and initiative?)  Need to know for status effects
 

 
 KNOWN BUGS:
 1.  If enter new name and no other commands program crashes (new() in commands.swift)
 
 
 
 TO MODIFY:
 New Character Entry Method:
 (DONE) new character entry is confusing to use.  Prompts would be better
 (DONE) add option for quick entry without prompts like:  name 8 14/15 8
 - perhaps a while loop to enter them all without needing to type "new" then exit
 that loop when "end" is typed.
 - confirmation: Cat             HP 20/20    AC 9
 - and charLog: Character: Cat, Initiative: 8, HP: 20 / 20, AC: 9
    doesn't look tidy or informative.
 
 New Mechanics:
 - Way to permanently delete a character out of the charOrdered list if a mistake has been made
 
 Modified Mechanics:
 HP
 - For hp, just name and number like birbman 8 or birbman +9
 - can be done, just add to default, and check that number can be turned into integer
 and if not, report back that the command doesn't work.
 - after modifying, should display everything again with updated stats
 - making changes such as HP, needs a change confirmed printline

 - option to delete a character entirely if mistakes are made?
 - or option to modify its stats directly?
 
 Confirmation
 - If y/n for confirmation not entered, needs to re-show the confirmation prompt
 otherwise I don't know whether my input has been received or it's still waiting
 - need to sit down and design how all text is displayed so it is consistent across all
 screens and printouts
 - for character info, use padding instead of spaces.
 - perhaps AC should be higher up and initiative
 
 
 - when removing statuses and characters from battle, wording between the two is
 confusing.
 cat remove
 [] not found
 cat out
 Remove Cat from battle?
 y
 Cat is removed from battle
 
 
 when a character goes to 0 hp, only the status unconscious is recorded and not
 the losing of the hp to that stage
 
 
 
 - are all the confirmations necessary?  (Check last after extended testing)
 
 
 Complete:
 - the display of turns and info doesn't look great.  Confusing and messy
 
 
 

 
 */
