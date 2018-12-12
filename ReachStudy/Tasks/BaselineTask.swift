//
//  BaselineTasl.swift
//  ReachStudy
//
//  Created by Franziska Lang on 06.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit
import Firebase

class BaselineTask: GridTargets {
    
    
    override func activateButton(_ sender: UIButton) {
        let number = randomNumbers[frames]
        
        if sender.tag == number {
            updateScreen()
        }
    }
   
}
