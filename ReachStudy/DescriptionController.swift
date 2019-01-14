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
        
        
        descriptionText.text = "Du startest gleich mit der \(sequence[counter]). Methode\n\nDu wirst immer zuerst drei Übungsziele bekommen mit denen du dich an die an die Technik gewöhnen kannst. Drücke den Button sobald er gelb aufläuchtet.\n Danach bekommst du 40 Ziele die du so genau und so schnell wie möglich anklicken sollst."
        
    }
    
    @IBAction func startTraining(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Calibration") as? CalibrationViewController {
            vc.data = data!
            vc.condition = sequence[counter]
            vc.counter = counter
            
            present(vc, animated: true, completion: nil)
        }
    }
    
}
