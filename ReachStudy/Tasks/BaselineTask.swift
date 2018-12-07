//
//  BaselineTasl.swift
//  ReachStudy
//
//  Created by Franziska Lang on 06.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit
import Firebase

class BaselineTask: GridTargets {
    
    
    
    func activateTaskButtons(_ sender: UIButton, _ frames: Int, _ count: Int) {
        sender.backgroundColor = UIColor.green
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if frames < count {
                sender.backgroundColor = UIColor.gray
                /*if frames < 8 {
                 print(frames)
                 self.frames += 1
                 //self.gridTargets[randomNumbers[frames]-1].backgroundColor = UIColor.gray
                 self.gridTargets[self.randomNumbers[frames]].backgroundColor = UIColor.yellow
                 let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
                 let position = [self.gridTargets[self.randomNumbers[frames]].frame.origin.x, self.gridTargets[self.randomNumbers[frames]].frame.origin.y]
                 self.data.conditions[self.condition!-1].targetProperties[self.randomNumbers[frames]].highlightTimestamp = "\(timestamp)"
                 self.ref = Database.database().reference().child("Participant \(self.data.participantID)").child("Condition \(self.data.conditions[self.condition!-1].conditionId)").child("Target \(self.data.conditions[self.condition!-1].targetProperties[self.randomNumbers[frames]].targetId)")
                 self.ref.updateChildValues(["Highlight Timestamp": timestamp, "Target Position": position])
                 self.frames += 1
                 } else if frames == 8 {
                 for button in self.gridTargets {
                 button.isHidden = true
                 self.finishButton.isHidden = false
                 }
                 }*/
            }
        }
    }
    
    override func activateButton(_ sender: UIButton) {
        let number = randomNumbers[frames]
        let currentFrames = frames
        
        if sender.tag == number {
            gridTargets[number].backgroundColor = UIColor.green
           
            let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
            let position = [gridTargets[randomNumbers[frames]].frame.origin.x, gridTargets[randomNumbers[frames]].frame.origin.y]
            
            //data.conditions[condition].targetProperties[targetID].highlightTimestamp = "\(timestamp)"
            let ref = Database.database().reference().child("Participant \(data.participantID)").child("Condition \(data.conditions[condition!-1].conditionId)").child("Target \(data.conditions[condition!-1].targetProperties[randomNumbers[frames]].targetId)")
            ref.updateChildValues(["Touch Timestamp": timestamp, "Touch Position": position])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if currentFrames < 7 {
                    
                    self.gridTargets[number].backgroundColor = UIColor.gray
                self.gridTargets[self.randomNumbers[currentFrames+1]].backgroundColor = UIColor.yellow
                    
                    self.saveTargetData(self.data, self.gridTargets[self.randomNumbers[currentFrames+1]], self.randomNumbers[currentFrames+1], self.condition!-1)
                    
                    
                } else if currentFrames == 7 {
                    for button in self.gridTargets {
                        button.isHidden = true
                        self.finishButton.isHidden = false
                    }
                }
            }
            self.frames += 1
        }
    }
   
    
    
    /*func activateButtons(_ targets: [UIButton], _ randomNumbers: [Int], _ finishButton: UIButton, _ data: Dataset, _ condition: Int, _ frames: Int, _ count: Int) -> Int {
     targets[randomNumbers[frames]].backgroundColor = UIColor.green
     
     let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
     let position = [targets[randomNumbers[frames]].frame.origin.x, targets[randomNumbers[frames]].frame.origin.y]
     
     //data.conditions[condition].targetProperties[targetID].highlightTimestamp = "\(timestamp)"
     let ref = Database.database().reference().child("Participant \(data.participantID)").child("Condition \(data.conditions[condition-1].conditionId)").child("Target \(data.conditions[condition-1].targetProperties[randomNumbers[frames]].targetId)")
     ref.updateChildValues(["Touch Timestamp": timestamp, "Touch Position": position])
     
     DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
     if frames < count {
     
     targets[randomNumbers[frames]].backgroundColor = UIColor.gray
     targets[randomNumbers[frames+1]].backgroundColor = UIColor.yellow
     
     self.saveTargetData(data, targets[randomNumbers[frames+1]], randomNumbers[frames+1], condition-1)
     
     
     
     
     } else if frames == count {
     for button in targets {
     button.isHidden = true
     finishButton.isHidden = false
     }
     }
     }
     return frames + 1
     }*/
    
    
    
    func saveTargetData(_ data: Dataset, _ target: UIButton, _ targetID: Int, _ condition: Int) {
     
     //let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
     //let position = [targets[randomNumbers[frames]].frame.origin.x, targets[randomNumbers[frames]].frame.origin.y]
     
     let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
     let position = [target.frame.origin.x, target.frame.origin.y]
     
     //data.conditions[condition].targetProperties[targetID].highlightTimestamp = "\(timestamp)"
     let ref = Database.database().reference().child("Participant \(data.participantID)").child("Condition \(data.conditions[condition].conditionId)").child("Target \(data.conditions[condition].targetProperties[targetID].targetId)")
     ref.updateChildValues(["Highlight Timestamp": timestamp, "Target Position": position])
     }
    
    
    
}
