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
    
  
    let gazeView: UIView = UIView()
    
    var trackerTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        gazeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: topArea)
        gazeView.backgroundColor = UIColor.red
        gazeView.layer.cornerRadius = 40
        gazeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        gazeView.alpha = 0.3
        self.view.addSubview(gazeView)
        
        borderView.isHidden = false
        
    }
    
    
    @objc func updateTimer() {
        let eyePosition = EyeTracker.getTrackerPosition()
        
        if eyePosition.y > -40 && eyePosition.y < topArea && eyePosition.x > -10 && eyePosition.x < self.view.frame.width && !viewIsMoved {
            self.view.layer.cornerRadius = 40
            UIView.animate(withDuration: 0.4) {
                self.view.frame.origin.y += self.moveDistance
            }
            viewIsMoved = true
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        let position = touch.location(in: self.view)
        
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
