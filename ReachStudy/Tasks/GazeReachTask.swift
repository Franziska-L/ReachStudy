//
//  GazeReachTask.swift
//  ReachStudy
//
//  Created by Franziska Lang on 06.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class GazeReachTask: GridTargets {
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    let gazeView: UIView = UIView()
    
    var trackerTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        gazeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: navigationBarHeight)
        gazeView.backgroundColor = UIColor.red
        gazeView.alpha = 0.3
        self.view.sendSubviewToBack(gazeView)
        
        borderView.isHidden = false
        
    }
    
    @IBAction func refreshCalibration(_ sender: Any) {
        refresh()
    }
    
    @objc func updateTimer() {
        let eyePosition = EyeTracker.getTrackerPosition()
        self.navigationBar.frame.origin.y = 44

        if eyePosition.y > -40 && eyePosition.y < navigationBarHeight && eyePosition.x > -10 && eyePosition.x < self.view.frame.width && !viewIsMoved {
            self.view.layer.cornerRadius = 40
            UIView.animate(withDuration: 0.4) {
                self.view.frame.origin.y += self.moveDistance
            }
            viewIsMoved = true
        }
        
        if eyePosition.y < middle {
            EyeTracker.instance.trackerView.backgroundColor = UIColor.red
            EyeTracker.instance.trackerView.alpha = 0.5
        } else {
            EyeTracker.instance.trackerView.alpha = 0.2
            EyeTracker.instance.trackerView.backgroundColor = UIColor.gray
        }
    }
    
    override func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        let pos = gesture.location(in: self.view)

        if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            if viewIsMoved {
                addPositionsToArray(pos, swipeUp)
                
                UIView.animate(withDuration: 0.4) {
                    self.navigationBar.frame.origin.y = 44
                    self.view.frame.origin.y -= self.moveDistance
                }
                viewIsMoved = false
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        let position = touch.location(in: self.view)
        
        addPositionsToArray(position, up)
        
        if frames < 8 && viewIsMoved && targets[randomNumbers[frames]].tag < 4 {
            if checkPosition(position: position, target: targets[randomNumbers[frames]]) {
                updateScreen()
            }
        } else if frames < 8 && !viewIsMoved && targets[randomNumbers[frames]].tag >= 4 {
            if checkPosition(position: position, target: targets[randomNumbers[frames]]) {
                updateScreen()
            }
        }
    }
    
    
}
