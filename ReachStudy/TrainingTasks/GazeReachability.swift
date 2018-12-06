//
//  GazeReachability.swift
//  ReachStudy
//
//  Created by Franziska Lang on 05.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class GazeReachability: GazeBasedController {
    
    let topArea: CGFloat = 1/5 * UIScreen.main.bounds.height
    let rightArea: CGFloat = 3/4 * UIScreen.main.bounds.width
    
    var viewIsMoved = false
    let moveDistance: CGFloat = 300
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        EyeTracker.delegate = nil
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if viewIsMoved {
            self.view.frame.origin.y -= moveDistance
            viewIsMoved = false
            EyeTracker.instance.trackerView.isHidden = false
            //EyeTracker.instance.trackerView.frame = CGRect(x: -50, y: -50, width: 50, height: 50)
        }
    }
    
    @objc func updateTimer() {
        let eyePosition = EyeTracker.getTrackerPosition()
        
        if eyePosition.y > 0 && eyePosition.y < topArea && eyePosition.x > rightArea && eyePosition.x < UIScreen.main.bounds.width && !viewIsMoved {
            print(topArea)
            print(rightArea)
            print(eyePosition)
            EyeTracker.instance.trackerView.isHidden = true
            self.view.layer.cornerRadius = 40
            self.view.frame.origin.y += moveDistance
            viewIsMoved = true
        }
    }
    
}
