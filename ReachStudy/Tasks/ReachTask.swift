//
//  ReachTask.swift
//  ReachStudy
//
//  Created by Franziska Lang on 06.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class ReachTask: GridTargets {
    
    var viewIsMoved = false
    let moveDistance: CGFloat = 350
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            if viewIsMoved {
                UIView.animate(withDuration: 0.4) {
                    self.view.frame.origin.y -= self.moveDistance
                }
                viewIsMoved = false
            }
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            if !viewIsMoved {
                self.view.layer.cornerRadius = 40
                UIView.animate(withDuration: 0.4) {
                    self.view.frame.origin.y += self.moveDistance
                }
                
                viewIsMoved = true
            }
        }
    }
    
    
    override func activateButton(_ sender: UIButton) {
        let number = randomNumbers[frames]
        
        if sender.tag == number {
            updateScreen()
        }
    }
}
