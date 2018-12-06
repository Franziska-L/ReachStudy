//
//  GazeBasedController.swift
//  Cclick
//
//  Created by Franziska Lang on 13.11.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class GazeBasedController: TrainingTargets, TrackerDelegate {
    
    
    var trackerPosition: CGPoint = CGPoint()
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EyeTracker.delegate = self
        
    }
    
    func getView() -> UIView {
        return self.view 
    }
    
    func checkPosition(position: CGPoint) {
        
        /*if counter < 9 {
            let offset: CGFloat = 10.0
            let minX = targetPositions[counter].x - offset
            let minY = targetPositions[counter].y - offset
            let maxX = targetPositions[counter].x + targetSize.width + offset
            let maxY = targetPositions[counter].y + targetSize.height + offset
            
            if position.x > minX && position.x < maxX && position.y > minY && position.y < maxY {
                isTargetActive = true
            } else {
                isTargetActive = false
            }
        }*/
    }
}
