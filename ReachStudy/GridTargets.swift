//
//  GridTargets.swift
//  Cclick
//
//  Created by Franziska Lang on 14.11.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit
import Firebase

class GridTargets: TargetViewController {
    
    var ref: DatabaseReference!
    var finishButton: UIButton = UIButton()
    
    
    //var timer = Timer()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishButton.frame = CGRect(x: 100, y: 500, width: 200, height: 60)
        finishButton.setTitle("Fertig", for: .normal)
        finishButton.setTitleColor(UIColor.blue, for: .normal)
        finishButton.addTarget(self, action: #selector(finishTask), for: .touchUpInside)
        self.view.addSubview(finishButton)
        
        finishButton.isHidden = true
        
        randomNumbers = Utility().generateRandomSequence(from: 0, to: 7, quit: 8)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.frames == 0 {
                self.targets[self.randomNumbers[self.frames]].backgroundColor = UIColor.yellow
                
                self.setDataTarget()
            }
        }
        //timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateScreen), userInfo: nil, repeats: true)
        
        let x1: CGFloat = 70
        let x2: CGFloat = 250
        let y1: CGFloat = 100
        let y2: CGFloat = 300
        let y3: CGFloat = 500
        let y4: CGFloat = 700
         
        targetPositions = [
         CGPoint(x: x1, y: y1),
         CGPoint(x: x2, y: y1),
         CGPoint(x: x1, y: y2),
         CGPoint(x: x2, y: y2),
         CGPoint(x: x1, y: y3),
         CGPoint(x: x2, y: y3),
         CGPoint(x: x1, y: y4),
         CGPoint(x: x2, y: y4)]
        
    
        for index in 0...targetPositions.count - 1 {
            let target: UIButton = UIButton()
            target.frame = CGRect(origin: targetPositions[index], size: targetSize)
            target.backgroundColor = UIColor.gray
            target.layer.cornerRadius = targetSize.width / 2
            target.tag = index
            
            if condition == 1 || condition == 2 || condition == 3 || condition == 6 {
                target.addTarget(self, action: #selector(activateButton), for: .touchUpInside)
            } else if condition == 5 {
                if index > 3 {
                    target.addTarget(self, action: #selector(activateButton), for: .touchUpInside)
                }
            }
            
            //setTargetPosition(position: targetPositions[index])
            
            self.view.addSubview(target)
            targets.append(target)
        }
    }
    
    @objc func activateButton(_ sender: UIButton) {}
    
    func updateScreen() {
        let number = randomNumbers[frames]
        let currentFrames = frames
        
        targets[number].backgroundColor = UIColor.green
        
        setTimestamp(for: "Touch")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if currentFrames < 7 {
                
                self.targets[number].backgroundColor = UIColor.gray
                self.targets[self.randomNumbers[currentFrames+1]].backgroundColor = UIColor.yellow
                
                self.setDataTarget()
                
            } else if currentFrames == 7 {
                for button in self.targets {
                    button.isHidden = true
                    self.finishButton.isHidden = false
                }
            }
        }
        self.frames += 1
    }
    
    func setDataTarget() {
        
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        let position = [targets[randomNumbers[frames]].frame.origin.x, targets[randomNumbers[frames]].frame.origin.y]
        
        self.data.conditions[condition!-1].targetProperties[randomNumbers[frames]].highlightTimestamp = "\(timestamp)"
        ref = Database.database().reference().child("Participant \(data.participantID)").child("Condition \(data.conditions[condition!-1].conditionId)").child("Target \(data.conditions[condition!-1].targetProperties[randomNumbers[frames]].targetId)")
        ref.updateChildValues(["Highlight Timestamp": timestamp, "Target Position": position])
    }
    
    
    func setTimestamp(for target: String) {
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        
        self.data.conditions[condition!-1].targetProperties[randomNumbers[frames]].highlightTimestamp = "\(timestamp)"
        
        ref = Database.database().reference().child("Participant \(data.participantID)").child("Condition \(data.conditions[condition!-1].conditionId)").child("Target \(data.conditions[condition!-1].targetProperties[randomNumbers[frames]].targetId)")
        ref.updateChildValues(["\(target) Timestamp": timestamp])
    }
    
    
    @objc func finishTask() {
        if counter < 6 {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DescriptionController") as? DescriptionController {
                vc.data = data
                vc.counter = counter + 1
                
                present(vc, animated: true, completion: nil)
            } else if counter == 6 {
                print("Alert hier fertig!")
            }
        }
    }
    
}
