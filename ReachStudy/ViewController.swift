//
//  ViewController.swift
//  ReachStudy
//
//  Created by Franziska Lang on 04.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
   
    @IBOutlet weak var participantIDLabel: UITextField!
    
    var ref: DatabaseReference!
    let data = Dataset()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func start(_ sender: Any) {
        if participantIDLabel.text == "" {
            errorField(participantIDLabel)
        } else {
            ref = Database.database().reference().child("Participant \(participantIDLabel.text!)")
            let key = ref.key
            
            data.participantID = participantIDLabel.text!
            
            setSequence()
            
            
            ref.setValue(["Participant ID": participantIDLabel.text])
            for i in 0 ..< data.conditions.count {
                ref = Database.database().reference().child(key!).child("Condition \(data.conditions[i].conditionId)")
                ref.setValue([
                    "Condition ID": data.conditions[i].conditionId,
                    "Total Time": 0])
                for targetID in 0...7 {
                    ref.child("Target \(targetID)").setValue([
                        "Target ID": targetID,
                        "Highlight Timestamp": "",
                        "Touch Timestamp": "",
                        "Target Position": [],
                        "Touch Positions": [],
                        "Eye Positions": [],
                        "Touch In Target": false,
                        "Distance": ""
                        ])
                    let targetProperty = TargetProperty(targetId: String(targetID))
                    data.conditions[i].targetProperties.append(targetProperty)
                }
            }
            self.performSegue(withIdentifier: "description", sender: self)
        }
    }
    
    func errorField(_ textField: UITextField){
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.red.cgColor
        
    }
    
    func setSequence() {
        if data.participantID != "" {
            let remainder = Int(data.participantID)! % 6
            switch remainder {
            case 1:
                data.conditions.append(Condition(conditionId: "1"))
                data.conditions.append(Condition(conditionId: "2"))
                data.conditions.append(Condition(conditionId: "6"))
                data.conditions.append(Condition(conditionId: "3"))
                data.conditions.append(Condition(conditionId: "5"))
                data.conditions.append(Condition(conditionId: "4"))
                break
            case 2:
                data.conditions.append(Condition(conditionId: "2"))
                data.conditions.append(Condition(conditionId: "3"))
                data.conditions.append(Condition(conditionId: "1"))
                data.conditions.append(Condition(conditionId: "4"))
                data.conditions.append(Condition(conditionId: "6"))
                data.conditions.append(Condition(conditionId: "5"))
                break
            case 3:
                data.conditions.append(Condition(conditionId: "3"))
                data.conditions.append(Condition(conditionId: "4"))
                data.conditions.append(Condition(conditionId: "2"))
                data.conditions.append(Condition(conditionId: "5"))
                data.conditions.append(Condition(conditionId: "1"))
                data.conditions.append(Condition(conditionId: "6"))
                break
            case 4:
                data.conditions.append(Condition(conditionId: "4"))
                data.conditions.append(Condition(conditionId: "5"))
                data.conditions.append(Condition(conditionId: "3"))
                data.conditions.append(Condition(conditionId: "6"))
                data.conditions.append(Condition(conditionId: "2"))
                data.conditions.append(Condition(conditionId: "1"))
                break
            case 5:
                data.conditions.append(Condition(conditionId: "5"))
                data.conditions.append(Condition(conditionId: "6"))
                data.conditions.append(Condition(conditionId: "4"))
                data.conditions.append(Condition(conditionId: "1"))
                data.conditions.append(Condition(conditionId: "3"))
                data.conditions.append(Condition(conditionId: "2"))
                break
            case 0:
                data.conditions.append(Condition(conditionId: "6"))
                data.conditions.append(Condition(conditionId: "1"))
                data.conditions.append(Condition(conditionId: "5"))
                data.conditions.append(Condition(conditionId: "2"))
                data.conditions.append(Condition(conditionId: "4"))
                data.conditions.append(Condition(conditionId: "3"))
                break
            default:
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "description" {
            if let vc = segue.destination as? DescriptionController {
                vc.data = data
                vc.counter = 0
            }
        }
    }
}

