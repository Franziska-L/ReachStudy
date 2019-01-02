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
    
    
    var timer = Timer()
    var totalTime = 0
    
    var eyePositions = [[CGFloat]]()
    var cursorPositions = [[CGFloat]]()
    var touchPositions = [[CGFloat]]()
    
    var repeats = 0
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        finishButton.center = self.view.center
        finishButton.setTitle("Fertig", for: .normal)
        finishButton.setTitleColor(UIColor.blue, for: .normal)
        finishButton.addTarget(self, action: #selector(finishTask), for: .touchUpInside)
        self.view.addSubview(finishButton)
        
        finishButton.isHidden = true
        
        randomNumbers = Utility().generateRandomSequence(from: 0, to: 7, quit: 8)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countTime), userInfo: nil, repeats: true)
        
        let x1: CGFloat = 60
        let x2: CGFloat = 245
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
            let target: UIView = UIView()
            target.frame = CGRect(origin: targetPositions[index], size: targetSize)
            target.backgroundColor = UIColor.gray
            target.layer.cornerRadius = targetSize.width / 2
            target.tag = index
            target.isHidden = true
            
            self.view.addSubview(target)
            targets.append(target)
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.targets[self.randomNumbers[0]].isHidden = false
            self.targets[self.randomNumbers[0]].backgroundColor = UIColor.yellow
            
            self.setDataTarget()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EyeTracker.delegate = self 
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        let touchPosition = touch.location(in: self.view)
        
        let eyePosition = EyeTracker.getTrackerPosition()
        
        addPositionsToArray(eyePosition, touchPosition)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        
        let touchPosition = touch.location(in: self.view)
        let eyePosition = EyeTracker.getTrackerPosition()
        
        addPositionsToArray(eyePosition, touchPosition)
        
        if frames < 8 {
            
            let isActive = checkPosition(position: touchPosition, target: targets[randomNumbers[frames]])
            
            if isActive {
                updateScreen()
            }
        }
    }
    
    @objc func countTime() {
        totalTime += 1
    }
    
    func addPositionsToArray(_ eyePosition: CGPoint, _ touchPosition: CGPoint) {
        let touchPos = [touchPosition.x, touchPosition.y]
        touchPositions.append(touchPos)
        
        let eyePos = [eyePosition.x, eyePosition.y]
        eyePositions.append(eyePos)
    }
    
        
    func updateScreen() {
        let number = randomNumbers[frames]
        let currentFrames = frames
        
        targets[number].backgroundColor = UIColor.green
        
        setTimestamp(for: "Touch")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if currentFrames < 7 {
                
                self.targets[number].backgroundColor = UIColor.gray
                self.targets[number].isHidden = true
                
                self.targets[self.randomNumbers[currentFrames+1]].backgroundColor = UIColor.yellow
                self.targets[self.randomNumbers[currentFrames+1]].isHidden = false
                
                self.setDataTarget()
                
            } else if currentFrames == 7 {
                self.targets[number].isHidden = true
                self.finishButton.isHidden = false
                self.borderView.isHidden = true
                    
                self.timer.invalidate()
                self.setTotalTime()
                if self.counter == 5 {
                    let label = UILabel()
                    label.frame = CGRect(x: 0, y: 200, width: self.view.frame.width, height: 120)
                    label.numberOfLines = 2
                    label.textAlignment = .center
                    label.center.x = self.view.center.x
                    label.text = "Du hast es geschafft! \nDanke für deine Teilnahme."
                    label.textColor = UIColor.blue
                    self.view.addSubview(label)
                }
            }
        }
        self.frames += 1
    }
    
    
    func setDataTarget() {
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        let position = [targets[randomNumbers[frames]].frame.origin.x, targets[randomNumbers[frames]].frame.origin.y]
        
        ref = Database.database().reference().child("Participant \(data.participantID)").child("Condition \(condition!)").child("Target \(data.conditions[counter].targetProperties[randomNumbers[frames]].targetId)")
        ref.updateChildValues(["Highlight Timestamp": timestamp, "Target Position": position])
       
    }
    
    
    func setTimestamp(for target: String) {
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        
        
        ref = Database.database().reference().child("Participant \(data.participantID)").child("Condition \(condition!)").child("Target \(data.conditions[counter].targetProperties[randomNumbers[frames]].targetId)")
        ref.updateChildValues(["\(target) Timestamp": timestamp, "Touch Positions": touchPositions, "Eye Positions": eyePositions, "Cursor Positions": cursorPositions])
        touchPositions.removeAll()
        eyePositions.removeAll()
        cursorPositions.removeAll()
    }
    
    
    func setTotalTime() {
        ref = Database.database().reference().child("Participant \(data.participantID)").child("Condition \(condition!)")
        ref.updateChildValues(["Total Time": totalTime])
    }
   
    
    @objc func finishTask() {
        print("Counter: \(counter)")
        if counter < 5 {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DescriptionController") as? DescriptionController {
                vc.data = data
                vc.counter = counter + 1
                
                present(vc, animated: true, completion: nil)
            }
        } else if counter == 5 {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Start") as? ViewController {
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
}
