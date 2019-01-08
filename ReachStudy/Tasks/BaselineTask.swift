//
//  BaselineTasl.swift
//  ReachStudy
//
//  Created by Franziska Lang on 06.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit
import Firebase

class BaselineTask: GridTargets {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EyeTracker.instance.trackerView.isHidden = true
    }
    
    
    @IBAction func refreshCalibration(_ sender: Any) {
        refresh()
    }
    
}
