//
//  Dataset.swift
//  ComboTouch
//
//  Created by Franziska Lang on 04.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit
import Firebase

class Dataset: NSObject {
    
    var participantID: String = ""
    var conditions: [Condition] = []

}


struct Condition {
    
    var conditionId: String = ""
    var targetProperties:[TargetProperty] = []
    

    init(conditionId: String) {
        self.conditionId = conditionId
    }
    
    init() {
        
    }
}

struct TargetProperty {
    var targetId: String = ""
    
    var highlightTimestamp: String = ""
    var touchTimestamp: String = ""
    
    var targetPosition: [Int] = []
    var touchPosition: String = ""
    var touchInTarget: Bool = false
    var touchToTargetDistance: String = ""
    
    init(targetId: String) {
        self.targetId = targetId
    }
}

