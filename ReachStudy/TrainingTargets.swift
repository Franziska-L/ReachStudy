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
        
        startTaskButton.frame = CGRect(x: 100, y: 500, width: 200, height: 60)
        startTaskButton.setTitle("Starte Training", for: .normal)
        startTaskButton.setTitleColor(UIColor.blue, for: .normal)
        startTaskButton.addTarget(self, action: #selector(startTask), for: .touchUpInside)
        self.view.addSubview(startTaskButton)
        
        startTaskButton.isHidden = true
        
        randomNumbers = Utility().generateRandomSequence(from: 0, to: 2, quit: 3)
        
        let x1: CGFloat = 50
        let x2: CGFloat = 170
        let x3: CGFloat = 300
        let y1: CGFloat = 100
        let y2: CGFloat = 300
        let y3: CGFloat = 500
        
        targetPositions = [
            CGPoint(x: x1, y: y1),
            CGPoint(x: x2, y: y2),
            CGPoint(x: x3, y: y3)]
        
        for index in 0...targetPositions.count-1 {
            let target: UIButton = UIButton()
            target.frame = CGRect(origin: targetPositions[index], size: targetSize)
            target.backgroundColor = UIColor.gray
            target.layer.cornerRadius = targetSize.width / 2
            target.tag = index
            if condition == 1 || condition == 6 {
                target.addTarget(self, action: #selector(activateButton), for: .touchUpInside)
            }

            self.view.addSubview(target)
            targets.append(target)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.frames == 0 {
                self.targets[self.randomNumbers[self.frames]].backgroundColor = UIColor.yellow
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
                self.targets[self.randomNumbers[currentFrames+1]].backgroundColor = UIColor.yellow
                
            } else if currentFrames == 2 {
                for button in self.targets {
                    button.isHidden = true
                    self.startTaskButton.isHidden = false
                }
            }
        }
        self.frames += 1
    }
    
    
    @objc func activateButton(_ sender: UIButton) {}
    @objc func startTask() {}
 
}
