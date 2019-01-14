//
//  GazeReachability.swift
//  ReachStudy
//
//  Created by Franziska Lang on 05.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class GazeReachability: TrainingTargets {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    let gazeView: UIView = UIView()
    
    var trackerTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateTrackerTimer), userInfo: nil, repeats: true)
        
        gazeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: navigationBarHeight)
        gazeView.backgroundColor = UIColor.red
        //gazeView.layer.cornerRadius = 40
        //gazeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        gazeView.alpha = 0.3
        self.view.addSubview(gazeView)
        
        borderView.isHidden = false
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EyeTracker.delegate = self

    }
    
    
    @objc func updateTrackerTimer() {
        let eyePosition = EyeTracker.getTrackerPosition()
        self.navigationBar.frame.origin.y = 44
        if eyePosition.y > -40 && eyePosition.y < navigationBarHeight && eyePosition.x > -10 && eyePosition.x < self.view.frame.width && !viewIsMoved {
            self.view.layer.cornerRadius = 40
            UIView.animate(withDuration: 0.4) {
                self.view.frame.origin.y += self.moveDistance
            }
            viewIsMoved = true
        }
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
    }
    
    override func startTask() {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GazeReachTask") as? GazeReachTask {
            vc.data = data
            vc.condition = condition
            vc.counter = counter
            
            present(vc, animated: true, completion: nil)
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
