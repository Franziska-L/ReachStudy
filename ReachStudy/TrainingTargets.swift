//
//  TrainingTargets.swift
//  ReachStudy
//
//  Created by Franziska Lang on 05.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//


import UIKit

class TrainingTargets: TargetViewController {
  
    
    var startTaskButton: UIButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTaskButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        startTaskButton.center = self.view.center
        startTaskButton.setTitle("Starte Aufgabe", for: .normal)
        startTaskButton.setTitleColor(UIColor.blue, for: .normal)
        startTaskButton.addTarget(self, action: #selector(startTask), for: .touchUpInside)
        self.view.addSubview(startTaskButton)
        
        startTaskButton.isHidden = true
        
        randomNumbers = Utility().generateRandomSequence(from: 0, to: 2, quit: 3)
        
        let x1: CGFloat = 30
        let x2: CGFloat = 152
        let x3: CGFloat = 275
        let y1: CGFloat = 100
        let y2: CGFloat = 300
        let y3: CGFloat = 500
        
        targetPositions = [
            CGPoint(x: x1, y: y1),
            CGPoint(x: x2, y: y2),
            CGPoint(x: x3, y: y3)]
        
        for index in 0...targetPositions.count-1 {
            let target: UIView = UIView()
            target.frame = CGRect(origin: targetPositions[index], size: targetSize)
            target.backgroundColor = UIColor.gray
            target.layer.cornerRadius = targetSize.width / 2
            target.tag = index
            //target.isHidden = true
            
            /*if condition == 1 || condition == 2 || condition == 3 || condition == 6 {
                target.addTarget(self, action: #selector(activateButton), for: .touchUpInside)
            } else if condition == 5 {
                if index > 1 {
                    target.addTarget(self, action: #selector(activateButton), for: .touchUpInside)
                }
            }*/

            self.view.addSubview(target)
            targets.append(target)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.targets[self.randomNumbers[0]].isHidden = false
            self.targets[self.randomNumbers[0]].backgroundColor = UIColor.yellow
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        
        let position = touch.location(in: self.view)

        if frames < 3 {
            
            let isActive = checkPosition(position: position, target: targets[randomNumbers[frames]])
            
            if isActive {
                updateScreen()
            }
        }
    }
    
    func updateScreen() {
        let number = randomNumbers[frames]
        let currentFrames = frames
        
        targets[number].backgroundColor = UIColor.green
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if currentFrames < 2 {
                
                self.targets[number].backgroundColor = UIColor.gray
                self.targets[number].isHidden = true

                self.targets[self.randomNumbers[currentFrames+1]].backgroundColor = UIColor.yellow
                self.targets[self.randomNumbers[currentFrames+1]].isHidden = false
                
            } else if currentFrames == 2 {
                self.targets[number].isHidden = true
                self.startTaskButton.isHidden = false
                //for button in self.targets {
                //    button.isHidden = true
                //}
            }
        }
        self.frames += 1
    }
    
    
    @objc func startTask() {}
    
 
}
