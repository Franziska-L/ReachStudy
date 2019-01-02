//
//  Reachability.swift
//  ReachStudy
//
//  Created by Franziska Lang on 05.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class Reachability: TrainingTargets {
  

    override func startTask() {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReachTask") as? ReachTask {
            vc.data = data
            vc.condition = condition
            vc.counter = counter
            
            present(vc, animated: true, completion: nil)
        }
    }
}
