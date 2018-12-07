//
//  GridTargets.swift
//  Cclick
//
//  Created by Franziska Lang on 14.11.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit
import Firebase

class GridTargets: UIViewController {
    
    var finishButton: UIButton = UIButton()
    var trackerPosition: CGPoint = CGPoint()
    
    var gridTargets: [UIButton] = [UIButton]()
    var targetPositions: [CGPoint] = [CGPoint]()
    let targetSize: CGSize = CGSize(width: 70, height: 70)
    var isTargetActive = false
    
    var timer = Timer()
    var totalTime = 0
    var frames = 0
    
    var randomNumbers = [Int]()
    var counter: Int = Int()

    var condition: Int?
    
    var data: Dataset = Dataset()
    var ref: DatabaseReference!
        
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
                self.gridTargets[self.randomNumbers[self.frames]].backgroundColor = UIColor.yellow
                //Baseline().saveTargetData(self.data, self.gridTargets[0], self.randomNumbers[0], self.condition!-1)
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
            if condition == 1 {
                target.addTarget(self, action: #selector(activateButton), for: .touchUpInside)
            }
            
            self.view.addSubview(target)
            gridTargets.append(target)
        }
    }
    
    @objc func activateButton(_ sender: UIButton) {
        switch condition {
        case 1:
            break
        case 2:
            //Reachability
            break
        case 3:
            //Gazebased reachbility
            break
        case 4:
            //Gazebased indirect touch
            break
        case 5:
            //Combo
            break
        case 6:
            //Combo with gaze
            break
        default:
            break
        }
    }
    
    @objc func updateScreen() {
        if frames < 8 {
            //self.gridTargets[randomNumbers[frames]-1].backgroundColor = UIColor.gray
            gridTargets[randomNumbers[frames]].backgroundColor = UIColor.yellow
            let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
            let position = [gridTargets[randomNumbers[frames]].frame.origin.x, gridTargets[randomNumbers[frames]].frame.origin.y]
            self.data.conditions[condition!-1].targetProperties[randomNumbers[frames]].highlightTimestamp = "\(timestamp)"
            ref = Database.database().reference().child("Participant \(data.participantID)").child("Condition \(data.conditions[condition!-1].conditionId)").child("Target \(data.conditions[condition!-1].targetProperties[randomNumbers[frames]].targetId)")
            ref.updateChildValues(["Highlight Timestamp": timestamp, "Target Position": position])
            frames += 1
        } else if frames == 8 {
            for button in gridTargets {
                button.isHidden = true
                finishButton.isHidden = false
            }
        }
    }
    
    func setTimestamp() {
        
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        let position = [gridTargets[randomNumbers[frames]].frame.origin.x, gridTargets[randomNumbers[frames]].frame.origin.y]
        
        self.data.conditions[condition!-1].targetProperties[randomNumbers[frames]].highlightTimestamp = "\(timestamp)"
        ref = Database.database().reference().child("Participant \(data.participantID)").child("Condition \(data.conditions[condition!-1].conditionId)").child("Target \(data.conditions[condition!-1].targetProperties[randomNumbers[frames]].targetId)")
        ref.updateChildValues(["Highlight Timestamp": timestamp, "Target Position": position])
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
