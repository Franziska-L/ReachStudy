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
    
    let middle: CGFloat = 1/2 * UIScreen.main.bounds.height
    
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Test")
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(eyeTrackerActive), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EyeTracker.delegate = self
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cursor.isHidden = true
        
        let position = cursor.frame.origin
        
        trackerActive = checkPosition(position: position, target: targets[randomNumbers[frames]])

        if trackerActive {
            updateScreen()
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
    
    
    override func activateButton(_ sender: UIButton) {
        let number = randomNumbers[frames]
        let currentFrames = frames
        
        if sender.tag == number && sender.tag > 1 {
            targets[number].backgroundColor = UIColor.green
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if currentFrames < 2 {
                    
                    self.targets[number].backgroundColor = UIColor.gray
                    self.targets[self.randomNumbers[currentFrames+1]].backgroundColor = UIColor.yellow
                    
                } else if currentFrames == 2 {
                    for button in self.targets {
                        button.isHidden = true
                        self.startTaskButton.isHidden = false
                    }
                }
            }
            self.frames += 1
        }
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
