//
//  Baseline.swift
//  ReachStudy
//
//  Created by Franziska Lang on 04.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class Baseline: TrainingTargets {
    
    
    override func startTask() {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BaselineTask") as? BaselineTask {
            vc.data = data
            vc.condition = condition
            vc.counter = counter
            
            present(vc, animated: true, completion: nil)
        }
    }
    
}
