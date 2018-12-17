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
        
        
        descriptionText.text = "Du startest gleich mit der \(sequence[counter]). Methode\n\nDu wirst immer zuerst drei Übungsziele bekommen mit denen du dich an die an die Technik gewöhnen kannst. Drücke den Button sobald er gelb aufläuchtet.\n Danach bekommst du 8 Ziele die du so genau und so schnell wie möglich anklicken sollst."
        
    }
    
    @IBAction func startTraining(_ sender: Any) {
        switch sequence[counter] {
        case 1:
            //Baseline
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Baseline") as? Baseline {
                vc.data = data!
                vc.condition = sequence[counter]
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 2:
            //Reachability
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Reachability") as? Reachability {
                vc.data = data!
                vc.condition = sequence[counter]
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 3:
            //Gazebased reachbility
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GazeReachability") as? GazeReachability {
                vc.data = data!
                vc.condition = sequence[counter]
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 4:
            //Gazebased indirect touch
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GazeTouch") as? GazeTouch {
                vc.data = data!
                vc.condition = sequence[counter]
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 5:
            //Combo
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComboNormal") as? ComboNormal {
                vc.data = data!
                vc.condition = sequence[counter]
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 6:
            //Combo with gaze
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComboGaze") as? ComboGaze {
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
    
}
