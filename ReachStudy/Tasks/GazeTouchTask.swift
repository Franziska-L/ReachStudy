//
//  GazeTouchTask.swift
//  ReachStudy
//
//  Created by Franziska Lang on 06.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class GazeTouchTask: GridTargets {
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EyeTracker.delegate = self
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let trackerPosition = EyeTracker.getTrackerPosition()
        setCursorPosition(position: trackerPosition)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        
        let prevLocaiton = touch.previousLocation(in: self.view)
        let newLocation = touch.location(in: self.view)
        
        let distX: CGFloat = newLocation.x - prevLocaiton.x
        let distY: CGFloat = newLocation.y - prevLocaiton.y
        
        let cursorPosition = cursor.frame.origin
        
        let x = cursorPosition.x + distX
        let y = cursorPosition.y + distY
        
        cursor.frame = CGRect(x: x, y: y, width: cursorSize, height: cursorSize)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cursor.isHidden = true
        
        let position = cursor.frame.origin
       
        if frames < 8 {
            let isActive = checkPosition(position: position, target: targets[randomNumbers[frames]])
            
            if isActive {
                updateScreen()
            }
        }
    }
    
    
}
