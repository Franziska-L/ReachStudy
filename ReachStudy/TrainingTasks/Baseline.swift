//
//  Baseline.swift
//  ReachStudy
//
//  Created by Franziska Lang on 04.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class Baseline: TrainingTargets {
    
    
    override func activateButton(_ sender: UIButton) {
        let number = randomNumbers[frames]
        let currentFrames = frames

        if sender.tag == number {
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
    }
    
    override func startTask() {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BaselineTask") as? BaselineTask {
            vc.data = data
            vc.condition = condition
            vc.counter = counter
            
            present(vc, animated: true, completion: nil)
        }
    }
    
}
