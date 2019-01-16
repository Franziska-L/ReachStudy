//
//  Reachability.swift
//  ReachStudy
//
//  Created by Franziska Lang on 05.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class Reachability: TrainingTargets {
    
    @IBOutlet weak var arrowDown: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.layer.cornerRadius = 40
        borderView.isHidden = false
    }
//    
//    override func startTask() {
//        
//        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReachTask") as? ReachTask {
//            vc.data = data
//            vc.condition = condition
//            vc.counter = counter
//            
//            present(vc, animated: true, completion: nil)
//        }
//    }
    
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
        
        if frames < 3 && viewIsMoved && targets[randomNumbers[frames]].tag < 2 {
            if checkPosition(position: position, target: targets[randomNumbers[frames]]) {
                updateScreen()
            }
        } else if frames < 3 && !viewIsMoved && targets[randomNumbers[frames]].tag == 2 {
            
            if checkPosition(position: position, target: targets[randomNumbers[frames]]) {
                updateScreen()
            }
        }
    }
}
