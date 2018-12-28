//
//  GazeReachTask.swift
//  ReachStudy
//
//  Created by Franziska Lang on 06.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class GazeReachTask: GridTargets {
    
    let topArea: CGFloat = 1/10 * UIScreen.main.bounds.height
    let rightArea: CGFloat = 3/4 * UIScreen.main.bounds.width
    
    var viewIsMoved = false
    let moveDistance: CGFloat = 350
    
    let gazeView: UIView = UIView()
    
    var trackerTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        gazeView.frame = CGRect(x: 0, y: -30, width: view.frame.width, height: topArea)
        gazeView.backgroundColor = UIColor.red
        gazeView.layer.cornerRadius = 8
        gazeView.alpha = 0.3
        self.view.addSubview(gazeView)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //EyeTracker.delegate = self
        
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        
        if viewIsMoved {
            self.view.layer.cornerRadius = 40
            UIView.animate(withDuration: 0.4) {
                self.view.frame.origin.y -= self.moveDistance
            }
            
            viewIsMoved = false
        }
        
    }
    
    
    
    override func activateButton(_ sender: UIButton) {
        let number = randomNumbers[frames]
        let currentFrames = frames
        
        if sender.tag == number {
            targets[number].backgroundColor = UIColor.green
            setTimestamp(for: "Touch")
            
            if viewIsMoved {
                viewIsMoved = false
                EyeTracker.instance.trackerView.isHidden = false
                UIView.animate(withDuration: 0.4) {
                    self.view.frame.origin.y -= self.moveDistance
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if currentFrames < 7 {
                    
                    self.targets[number].backgroundColor = UIColor.gray
                    self.targets[self.randomNumbers[currentFrames+1]].backgroundColor = UIColor.yellow
                    
                    self.setDataTarget()
                    
                } else if currentFrames == 7 {
                    for button in self.targets {
                        button.isHidden = true
                        self.finishButton.isHidden = false
                        self.gazeView.isHidden = true
                        
                        self.timer.invalidate()
                        self.trackerTimer.invalidate()
                        self.setTotalTime()
                    }
                }
            }
            self.frames += 1
        }
    }
    
    
    
    @objc func updateTimer() {
        let eyePosition = EyeTracker.getTrackerPosition()
        
        if eyePosition.y > 0 && eyePosition.y < topArea && eyePosition.x > rightArea && eyePosition.x < UIScreen.main.bounds.width && !viewIsMoved {
            EyeTracker.instance.trackerView.isHidden = true
            self.view.layer.cornerRadius = 40
            UIView.animate(withDuration: 0.4) {
                self.view.frame.origin.y += self.moveDistance
            }
            viewIsMoved = true
        }
    }
    
    
}
