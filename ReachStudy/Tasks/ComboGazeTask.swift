//
//  ComboGazeTask.swift
//  ReachStudy
//
//  Created by Franziska Lang on 06.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class ComboGazeTask: GridTargets {
    
    var trackerActive = false
    
    var trackerTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        borderView.isHidden = false

        trackerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(eyeTrackerActive), userInfo: nil, repeats: true)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        trackerTimer.invalidate()
        EyeTracker.instance.trackerView.backgroundColor = UIColor.red
        EyeTracker.instance.trackerView.alpha = 0.5
    }
    
    @IBAction func refreshCalibration(_ sender: Any) {
        refresh()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let trackerPosition = EyeTracker.getTrackerPosition()
        
        let touch: UITouch! = touches.first
        let touchPosition = touch.location(in: self.view)
        
        addPositionsToArray(touchPosition, down)
    
        if trackerPosition.y < middle {
            setCursorPosition(position: trackerPosition)
            
            let cursorPos = cursor.frame.origin
            let roundedCursorX: CGFloat = (cursorPos.x * 100).rounded() / 100
            let roundedCursorY: CGFloat = (cursorPos.y * 100).rounded() / 100
            cursorPositions.append([roundedCursorX, roundedCursorY])
            
            trackerActive = true
        } else {
            trackerActive = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        
        let prevLocaiton = touch.previousLocation(in: self.view)
        let newLocation = touch.location(in: self.view)
        
        addPositionsToArray(newLocation, move)
        
        if trackerActive {
            let distX: CGFloat = newLocation.x - prevLocaiton.x
            let distY: CGFloat = newLocation.y - prevLocaiton.y
            
            let cursorPosition = cursor.frame.origin
            
            let x = cursorPosition.x + distX
            let y = cursorPosition.y + distY
            
            if frames < 8 && checkPosition(position: CGPoint(x: x, y: y), target: targets[randomNumbers[frames]]) {
                targets[randomNumbers[frames]].backgroundColor = UIColor(red: 255/255, green: 192/255, blue: 91/255, alpha: 1)
            } else if frames < 8 && !checkPosition(position: CGPoint(x: x, y: y), target: targets[randomNumbers[frames]]) {
                targets[randomNumbers[frames]].backgroundColor = UIColor.yellow
            }
            
            cursor.frame = CGRect(x: x, y: y, width: cursorSize, height: cursorSize)
            
            let roundedCursorX: CGFloat = (x * 100).rounded() / 100
            let roundedCursorY: CGFloat = (y * 100).rounded() / 100
            cursorPositions.append([roundedCursorX, roundedCursorY])
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cursor.isHidden = true
        
        let touch: UITouch! = touches.first
        let touchPosition = touch.location(in: self.view)
        
        addPositionsToArray(touchPosition, up)

        if frames < 8 && trackerActive {
            let cursorPos = cursor.frame.origin
            let isActive = checkPosition(position: cursorPos, target: targets[randomNumbers[frames]])
            
            let roundedCursorX: CGFloat = (cursorPos.x * 100).rounded() / 100
            let roundedCursorY: CGFloat = (cursorPos.y * 100).rounded() / 100
            cursorPositions.append([roundedCursorX, roundedCursorY])
            
            if isActive {
                updateScreen()
            }
        } else if frames < 8 && !trackerActive {
            let isActive = checkPosition(position: touchPosition, target: targets[randomNumbers[frames]])
            
            if isActive {
                updateScreen()
            }
        }
    }
    
    @objc func eyeTrackerActive() {
        let eyePosition = EyeTracker.getTrackerPosition()
        
        if eyePosition.y < middle {
            EyeTracker.instance.trackerView.backgroundColor = UIColor.red
            EyeTracker.instance.trackerView.alpha = 0.5
        } else {
            EyeTracker.instance.trackerView.alpha = 0.2
            EyeTracker.instance.trackerView.backgroundColor = UIColor.gray
        }
        
    }
    
}
