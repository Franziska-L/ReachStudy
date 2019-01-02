//
//  CalibrationViewController.swift
//  ReachStudy
//
//  Created by Franziska Lang on 02.01.19.
//  Copyright © 2019 Franziska Lang. All rights reserved.
//

import UIKit

class CalibrationViewController: UIViewController, TrackerDelegate {

    @IBOutlet weak var checkpoint: UIView!
    @IBOutlet weak var start: UIButton!
    
    var offsetX: CGFloat = CGFloat()
    var offsetY: CGFloat = CGFloat()
    
    var skip = 0
    var frames = 0
    
    var offX: [Int] = [0]
    var offY: [Int] = [0]
    
    var condition: Int?
    var counter: Int = Int()
    var data: Dataset = Dataset()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        start.isHidden = true
        self.reset()
        SCalibration.clear()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EyeTracker.delegate = self
    }
    
    func reset(){
        /*if SCalibration.offsetContinue() {
            self.frames = 0
            self.offX = [0]
            self.offY = [0]
            
            self.checkpoint.isHidden = false
        } else {
            self.checkpoint.isHidden = true
        }*/
        
        self.frames = 0
        self.offX = [0]
        self.offY = [0]
        
        self.checkpoint.isHidden = false
        
    }
    
   
    func execute(_ frame: CGRect) {
        
        if self.frames < 100 {
            self.checkpoint.backgroundColor = UIColor.yellow
        } else if self.frames >= 100 && self.frames < 200 {
            self.checkpoint.backgroundColor = UIColor.green
            self.adjustXY()
        } else if self.frames == 200 {
            SCalibration.setOffset(self.averageOffset(self.offX), y: self.averageOffset(self.offY))
            self.start.isHidden = false
            self.checkpoint.isHidden = true
            //self.reset()
        }
        
        self.frames += 1
    }
    
    
    func averageOffset(_ array: [Int]) -> Int{
        guard array.count > 0 else { return 0 }
        return array.reduce(0, +) / array.count
    }
    
    func adjustXY(){
        let eyePosition = EyeTracker.getTrackerPosition()
        self.offX.append(Int(self.checkpoint.frame.midX - eyePosition.x))
        self.offY.append(Int(self.checkpoint.frame.midY - eyePosition.y))
    }
    
    func getView() -> UIView {
        return self.view
    }
    
    @IBAction func startTraining(_ sender: Any) {
        switch condition {
        case 1:
            //Baseline
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Baseline") as? Baseline {
                vc.data = data
                vc.condition = condition
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 2:
            //Reachability
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Reachability") as? Reachability {
                vc.data = data
                vc.condition = condition
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 3:
            //Gazebased reachbility
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GazeReachability") as? GazeReachability {
                vc.data = data
                vc.condition = condition
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 4:
            //Gazebased indirect touch
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GazeTouch") as? GazeTouch {
                vc.data = data
                vc.condition = condition
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 5:
            //Combo
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComboNormal") as? ComboNormal {
                vc.data = data
                vc.condition = condition
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 6:
            //Combo with gaze
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComboGaze") as? ComboGaze {
                vc.data = data
                vc.condition = condition
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
    
    
}
