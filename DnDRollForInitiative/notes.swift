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
 - If going beyond max HP, no option to cancel entirely.  Max, beyond, cancel
 
 
 TO MODIFY:
 
 New Mechanics:
 - Way to permanently delete a character out of the charOrdered list if a mistake has been made
 
 Modified Mechanics:

 - option to delete a character entirely if mistakes are made?
 - or option to modify its stats directly?
 - If character has 0 HP and is unconscious and has HP added, remove unconscious status
 
 Confirmation
 - If y/n for confirmation not entered, needs to re-show the confirmation prompt
 otherwise I don't know whether my input has been received or it's still waiting
 

 
 when a character goes to 0 hp, only the status unconscious is recorded and not
 the losing of the hp to that stage
 
 when a character goes to 0 hp, give extra option to remove and hide from turn screen.
 
 give extra option to hide any character from turn screen?
 Or....  Once removed, hidden from turn screen anyway since the char list can be seen at any time
 
 
 - For other text fields like entering dex or y / n, make it so that accidental white spaces are cleaned up?
 
 

 
 
 */
