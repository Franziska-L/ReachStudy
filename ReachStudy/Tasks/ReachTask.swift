//
//  ReachTask.swift
//  ReachStudy
//
//  Created by Franziska Lang on 06.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class ReachTask: GridTargets {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        borderView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EyeTracker.instance.trackerView.isHidden = true
    }
    
    @IBAction func refreshCalibration(_ sender: Any) {
        refresh()
    }
    
    override func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            if viewIsMoved {
                UIView.animate(withDuration: 0.4) {
                    self.navigationBar.frame.origin.y = 44
                    self.view.frame.origin.y -= self.moveDistance
                }
                viewIsMoved = false
            }
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            if !viewIsMoved {
                UIView.animate(withDuration: 0.4) {
                    self.navigationBar.frame.origin.y = 44
                    self.view.frame.origin.y += self.moveDistance
                }
                viewIsMoved = true
            }
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
