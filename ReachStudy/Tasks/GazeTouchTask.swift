//
//  GazeTouchTask.swift
//  ReachStudy
//
//  Created by Franziska Lang on 06.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class GazeTouchTask: GridTargets {
    
    
    @IBAction func refreshCalibration(_ sender: Any) {
        refresh()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let trackerPosition = EyeTracker.getTrackerPosition()
        setCursorPosition(position: trackerPosition)
                
        let touch: UITouch! = touches.first
        let touchPosition = touch.location(in: self.view)
        
        addPositionsToArray(touchPosition, down)
        
        let timestamp = Date().toMillis()
        touchPositions_timestamp.append(timestamp)
        
        let cursorPos = cursor.frame.origin
        cursorPositions.append([cursorPos.x, cursorPos.y])
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        
        let prevLocaiton = touch.previousLocation(in: self.view)
        let newLocation = touch.location(in: self.view)
        
        let distX: CGFloat = newLocation.x - prevLocaiton.x
        let distY: CGFloat = newLocation.y - prevLocaiton.y
        
        let cursorPosition = cursor.frame.origin
        
        if frames < 8 && checkPosition(position: cursorPosition, target: targets[randomNumbers[frames]]) {
            targets[randomNumbers[frames]].backgroundColor = UIColor(red: 255/255, green: 192/255, blue: 91/255, alpha: 1)
        } else if frames < 8 && !checkPosition(position: cursorPosition, target: targets[randomNumbers[frames]]) {
            targets[randomNumbers[frames]].backgroundColor = UIColor.yellow
        }
        
        let x = cursorPosition.x + distX
        let y = cursorPosition.y + distY
        
        cursor.frame = CGRect(x: x, y: y, width: cursorSize, height: cursorSize)
        
        addPositionsToArray(newLocation, move)
        cursorPositions.append([x, y])
        
        let timestamp = Date().toMillis()
        touchPositions_timestamp.append(timestamp)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cursor.isHidden = true
        
        let touch: UITouch! = touches.first
        let touchPosition = touch.location(in: self.view)
        
        let position = cursor.frame.origin
       
        if frames < 8 {
            addPositionsToArray(touchPosition, up)
            cursorPositions.append([position.x, position.y])
            
            let timestamp = Date().toMillis()
            touchPositions_timestamp.append(timestamp)
            
            let isActive = checkPosition(position: position, target: targets[randomNumbers[frames]])
           
            if isActive {
                updateScreen()
            }
        }
    }
    
    
}
