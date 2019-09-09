//
//  charCommandTools.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/09.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation


func charHp() {
    
}


func charStatus() {
    
}


func charRemove() {
    
}


func charLeave() {
    
}


func charBack() {
    
}


func charInfo(charIndex: Int) {
    let charObj: Characters = charsOrdered[charIndex]
    let charName: String = charObj.charName
    let initiative: Int = charObj.initiative
    var hp: Int = charObj.hitPoints
    var maxHP: Int = charObj.maxHitPoints
    var statuses: [String] = charObj.statuses
    var participating: Bool = charObj.participating
    var armorClass: Int = charObj.armorClass
    
    var dexterity: Int?  //  can this change halfway through a battle?
    var order: Int?  // battle order
}


func charLog(charIndex: Int) {
    let charName: String = charsOrdered[charIndex].charName
    print("------------ \(charName)'s Change Log ------------")
    for change in charsOrdered[charIndex].changeLog {
        print(change)
    }
    print("------------ End of \(charName)'s Changes ------------")
}
