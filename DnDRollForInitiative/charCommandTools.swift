//
//  charCommandTools.swift
//  DnDRollForInitiative
//
//  Created by Keith Lee on 2019/09/09.
//  Copyright © 2019 Keith Lee. All rights reserved.
//

import Foundation


func charHp(charIndex: Int, modifier: String) {
    guard let modInt: Int = Int(modifier) else {
        print("Check format.  Should be like:\n" +
            "    birbman hp -7")
        return
    }
    charsOrdered[charIndex].modHitPoints(mod: modInt)
}


func charInfo(charIndex: Int) {
    let charObj: Characters = charsOrdered[charIndex]
    let charName: String = charObj.charName
    let participating: Bool = charObj.participating
    let initiative: Int = charObj.initiative
    let hp: Int = charObj.hitPoints
    let maxHP: Int = charObj.maxHitPoints
    let armorClass: Int = charObj.armorClass
    let statuses: [String] = charObj.statuses
    
    print("------------ \(charName.uppercased())'s Information ------------")
    if participating == true {
        print("In Battle")
    } else {
        print("Out of Battle")
    }
    print("Initiative:       [\(initiative)]")
    if let dexterity: Int = charObj.dexterity {
        print("Dexterity:        [\(dexterity)]")
    }
    print("Hit Points:       [\(hp) / \(maxHP)]")
    print("Armor Class:      [\(armorClass)]")
    if statuses.count > 0 {
        print("Status Effects:      \(statuses)")
    }
    print("------------ End of \(charName.uppercased())'s Information ------------")
}


func charLog(charIndex: Int) {
    let charName: String = charsOrdered[charIndex].charName
    print("------------ \(charName.uppercased())'s Change Log ------------")
    for change in charsOrdered[charIndex].changeLog {
        print(change)
    }
    print("------------ End of \(charName.uppercased())'s Changes ------------")
}
