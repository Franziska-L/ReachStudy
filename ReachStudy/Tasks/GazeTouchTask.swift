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
        
        let cursorPos = cursor.frame.origin
        addData(touchPosition: touchPosition, cursorPositionX: cursorPos.x, cursorPositionY: cursorPos.y, event: down)
        
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
        addData(touchPosition: newLocation, cursorPositionX: x, cursorPositionY: y, event: move)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cursor.isHidden = true
        
        let touch: UITouch! = touches.first
        let touchPosition = touch.location(in: self.view)
        
        let position = cursor.frame.origin
        addData(touchPosition: touchPosition, cursorPositionX: position.x, cursorPositionY: position.y, event: up)
        
        if frames < 8 {
            let isActive = checkPosition(position: position, target: targets[randomNumbers[frames]])
           
            if isActive {
                updateScreen()
            }
        }
    }
    
    func addData(touchPosition: CGPoint, cursorPositionX: CGFloat, cursorPositionY: CGFloat, event: CGFloat) {
        addPositionsToArray(touchPosition, event)
        
        let roundedCursorX: CGFloat = (cursorPositionX * 100).rounded() / 100
        let roundedCursorY: CGFloat = (cursorPositionY * 100).rounded() / 100
        cursorPositions.append([roundedCursorX, roundedCursorY])
    }
    
    
}
