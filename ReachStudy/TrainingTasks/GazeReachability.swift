//
//  GazeReachability.swift
//  ReachStudy
//
//  Created by Franziska Lang on 05.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class GazeReachability: TrainingTargets {
    
    let topArea: CGFloat = 1/10 * UIScreen.main.bounds.height
    let rightArea: CGFloat = 3/4 * UIScreen.main.bounds.width
    
    var viewIsMoved = false
    let moveDistance: CGFloat = 350
    
    let gazeView: UIView = UIView()
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        gazeView.frame = CGRect(x: rightArea, y: 30, width: rightArea/3, height: topArea)
        gazeView.backgroundColor = UIColor.red
        gazeView.layer.cornerRadius = 8
        gazeView.alpha = 0.3
        self.view.addSubview(gazeView)
        //let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        //swipeDown.direction = .down
        //self.view.addGestureRecognizer(swipeDown)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EyeTracker.delegate = self

    }
    
    
    
    override func activateButton(_ sender: UIButton) {
        let number = randomNumbers[frames]
        let currentFrames = frames
        
        if sender.tag == number {
            targets[number].backgroundColor = UIColor.green
            if viewIsMoved {
                viewIsMoved = false
                EyeTracker.instance.trackerView.isHidden = false
                UIView.animate(withDuration: 0.4) {
                    self.view.frame.origin.y -= self.moveDistance
                }
                //EyeTracker.instance.trackerView.frame = CGRect(x: -50, y: -50, width: 50, height: 50)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if currentFrames < 2 {
                    
                    self.targets[number].backgroundColor = UIColor.gray
                    self.targets[self.randomNumbers[currentFrames+1]].backgroundColor = UIColor.yellow
                    
                } else if currentFrames == 2 {
                    for button in self.targets {
                        button.isHidden = true
                        self.startTaskButton.isHidden = false
                        self.gazeView.isHidden = true
                    }
                }
            }
            self.frames += 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if viewIsMoved {
            UIView.animate(withDuration: 0.4) {
                self.view.frame.origin.y -= self.moveDistance
            }
            viewIsMoved = false
            EyeTracker.instance.trackerView.isHidden = false
            //EyeTracker.instance.trackerView.frame = CGRect(x: -50, y: -50, width: 50, height: 50)
        }
    }
    
    
    @objc func updateTimer() {
        let eyePosition = EyeTracker.getTrackerPosition()
        
        if eyePosition.y > 0 && eyePosition.y < topArea && eyePosition.x > rightArea && eyePosition.x < UIScreen.main.bounds.width && !viewIsMoved {
            EyeTracker.instance.trackerView.isHidden = true
            self.view.layer.cornerRadius = 40
            self.view.frame.origin.y += moveDistance
            viewIsMoved = true
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
    
}
