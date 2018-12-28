//
//  ComboGaze.swift
//  ReachStudy
//
//  Created by Franziska Lang on 05.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class ComboGaze: TrainingTargets {
 
    var trackerActive = false
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        borderView.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(eyeTrackerActive), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EyeTracker.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timer.invalidate()
        EyeTracker.instance.trackerView.backgroundColor = UIColor.red
        EyeTracker.instance.trackerView.alpha = 0.5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {        
        trackerPosition = EyeTracker.getTrackerPosition()
        
        if trackerPosition.y < middle {
            
           
            
            let x = EyeTracker.instance.trackerView.frame.size.width / 2 + trackerPosition.x - cursorSize/2
            let y = EyeTracker.instance.trackerView.frame.size.height / 2 + trackerPosition.y - cursorSize/2
            
            print(trackerPosition)
            print(x)
            print(y)
            
            cursor.frame = CGRect(x: x, y: y, width: cursorSize, height: cursorSize)
            cursor.isHidden = false
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cursor.isHidden = true
        
        if trackerActive && frames < 3 {
            let position = cursor.frame.origin
            let isActive = checkPosition(position: position, target: targets[randomNumbers[frames]])
            
            if isActive {
                updateScreen()
            }
        } else if !trackerActive && frames < 3 && targets[randomNumbers[frames]].tag > 1 {
            let touch: UITouch! = touches.first
            
            let touchPosition = touch.location(in: self.view)
            
            let isActive = checkPosition(position: touchPosition, target: targets[randomNumbers[frames]])
            
            if isActive {
                updateScreen()
            }
        }
        
        if frames == 3 {
            borderView.isHidden = true
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
        
        //trackerActive = checkPosition(position: eyePosition, target: targets[randomNumbers[frames]])
        
    }
    
    
    override func startTask() {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComboGazeTask") as? ComboGazeTask {
            vc.data = data
            vc.condition = condition
            vc.counter = counter
            
            present(vc, animated: true, completion: nil)
        }
    }
    

}
