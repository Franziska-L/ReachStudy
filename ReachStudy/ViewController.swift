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
    @IBOutlet weak var emptyIDLabel: UILabel!
    @IBOutlet weak var existingIDLabel: UILabel!
    
    var ref: DatabaseReference!
    let data = Dataset()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        emptyIDLabel.isHidden = true
        existingIDLabel.isHidden = true
    }
    
    
    @IBAction func start(_ sender: Any) {
        if participantIDLabel.text == "" {
            errorField(participantIDLabel, 0)
        } else {
            emptyIDLabel.isHidden = true
            let participantID = String(format: "%02d", Int(participantIDLabel.text!)!)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild("Participant \(participantID)") {
                    self.errorField(self.participantIDLabel, 1)
                } else {
                    self.existingIDLabel.isHidden = true
                    
                    self.data.participantID = participantID
                    self.setSequence()
                    
                    self.ref = self.ref.child("Participant \(participantID)")
                    self.ref.setValue(["Participant ID": participantID])
                    
                    for i in 0 ..< self.data.conditions.count {
                        self.ref = Database.database().reference().child("Participant \(participantID)").child("Condition \(self.data.conditions[i].conditionId)")
                        self.ref.setValue([
                            "Condition ID": self.data.conditions[i].conditionId,
                            "Total Time": 0])
                        for targetID in 1...40 {
                            let id = String(format: "%02d", targetID)
                            self.ref.child("Target \(id)").setValue([
                                "Target ID": ""                ])
                            let targetProperty = TargetProperty(targetId: String(targetID))
                            self.data.conditions[i].targetProperties.append(targetProperty)
                            
                        }
                    }
                    self.performSegue(withIdentifier: "description", sender: self)
                    
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func errorField(_ textField: UITextField, _ error: Int){
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.red.cgColor
        if error == 0 {
            emptyIDLabel.isHidden = false
        } else if error == 1 {
            existingIDLabel.isHidden = false
        }
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

