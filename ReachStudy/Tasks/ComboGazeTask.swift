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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //EyeTracker.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        trackerTimer.invalidate()
        EyeTracker.instance.trackerView.backgroundColor = UIColor.red
        EyeTracker.instance.trackerView.alpha = 0.5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let trackerPosition = EyeTracker.getTrackerPosition()

        if trackerPosition.y < middle {
            setCursorPosition(position: trackerPosition)
            trackerActive = true
        } else {
            trackerActive = false
        }
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
        
        let eyePosition = EyeTracker.getTrackerPosition()
        addPositionsToArray(eyePosition, newLocation)
        
        if trackerActive {
            cursorPositions.append([x, y])
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cursor.isHidden = true
        
        let touch: UITouch! = touches.first
        
        let touchPosition = touch.location(in: self.view)
        let eyePosition = EyeTracker.getTrackerPosition()
        
        if trackerActive && frames < 8 {
            let position = cursor.frame.origin
            let isActive = checkPosition(position: position, target: targets[randomNumbers[frames]])
            
            cursorPositions.append([position.x, position.y])
            addPositionsToArray(eyePosition, touchPosition)
            
            if isActive {
                updateScreen()
            }
        } else if !trackerActive && frames < 8 {
            addPositionsToArray(eyePosition, touchPosition)
            
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
