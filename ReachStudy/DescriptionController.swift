//
//  SecondViewController.swift
//  ReachStudy
//
//  Created by Franziska Lang on 04.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class DescriptionController: UIViewController {
    
    var data: Dataset?
    var sequence: [Int] = []
    var counter: Int = Int()
    
    @IBOutlet weak var descriptionText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0 ..< data!.conditions.count {
            sequence.append(Int(data!.conditions[index].conditionId)!)
        }
        
        print(counter)
        
        descriptionText.text = "Du startest gleich mit der \(sequence[counter]). Methode\n\nDu wirst immer zuerst drei Übungsziele bekommen mit denen du dich an die an die Technik gewöhnen kannst. Drücke den Button sobald er gelb aufläuchtet.\n Danach bekommst du 8 Ziele die du so genau und so schnell wie möglich anklicken sollst."
        
    }
    
    @IBAction func startTraining(_ sender: Any) {
        switch sequence[counter] {
        case 1:
            //Baseline
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BaselineTraining") as? Baseline {
                vc.data = data!
                vc.condition = sequence[counter]
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 2:
            //Reachability
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReachabilityTraining") as? Reachability {
                vc.data = data!
                vc.condition = sequence[counter]
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 3:
            //Gazebased reachbility
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GazeReachTraining") as? GazeReachability {
                vc.data = data!
                vc.condition = sequence[counter]
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 4:
            //Gazebased indirect touch
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GazeTouchTraining") as? GazeTouch {
                vc.data = data!
                vc.condition = sequence[counter]
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 5:
            //Combo
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComboNormalTraining") as? ComboNormal {
                vc.data = data!
                vc.condition = sequence[counter]
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 6:
            //Combo with gaze
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComboGazeTraining") as? ComboGaze {
                vc.data = data!
                vc.condition = sequence[counter]
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startBaseline" {
            if let vc = segue.destination as? TrainingTargets {
                vc.data = data!
                if counter < 6 {
                    vc.condition = sequence[counter]
                    vc.counter = counter
                }
            }
        }
    }*/
    
}
