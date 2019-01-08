//
//  CalibrationViewController.swift
//  ReachStudy
//
//  Created by Franziska Lang on 02.01.19.
//  Copyright © 2019 Franziska Lang. All rights reserved.
//

import UIKit
import Firebase

class CalibrationViewController: UIViewController, TrackerDelegate {

    @IBOutlet weak var checkpoint: UIView!
    @IBOutlet weak var checkpointMiddle: UIView!
    @IBOutlet weak var start: UIButton!
    
    var offsetX: CGFloat = CGFloat()
    var offsetY: CGFloat = CGFloat()
    
    var skip = 0
    var frames = 0
    
    var offX: [Int] = [Int]()
    var offY: [Int] = [Int]()
    
    var condition: Int?
    var counter: Int = Int()
    var data: Dataset = Dataset()
   
    var ref: DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkpoint.backgroundColor = UIColor.red
        checkpoint.layer.cornerRadius = 20
        
        checkpointMiddle.layer.cornerRadius = 5

        start.isHidden = true
        SCalibration.clear()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EyeTracker.delegate = self
        EyeTracker.instance.trackerView.isHidden = true
    }
    
   
    func execute(_ frame: CGRect) {
        
        if self.frames < 20 {
            self.checkpoint.backgroundColor = UIColor.red
        } else if self.frames < 100 {
            self.checkpoint.backgroundColor = UIColor.yellow
        } else if self.frames >= 100 && self.frames < 200 {
            self.checkpoint.backgroundColor = UIColor.green
            self.adjustXY()
        } else if self.frames == 200 {
            let averageX = self.averageOffset(self.offX)
            let averageY = self.averageOffset(self.offY)
            
            SCalibration.setOffset(averageX, y: averageY)
            setOffsetData(estimatedPoint: EyeTracker.getTrackerPosition(), calibrationPoint: checkpoint.frame.origin, offX: averageX, offY: averageY)
            
            EyeTracker.instance.trackerView.isHidden = false
            self.start.isHidden = false
            self.checkpoint.isHidden = true
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
    
    func setOffsetData(estimatedPoint: CGPoint, calibrationPoint: CGPoint, offX: Int, offY: Int) {
        
        let estPoint = [estimatedPoint.x, estimatedPoint.y]
        let calibPoint = [calibrationPoint.x, 90.0]
        let offXY = [offX, offY]
        
        ref = Database.database().reference().child("Participant \(data.participantID)").child("Condition \(condition!)")
        ref.updateChildValues(["Estimated Point": estPoint, "Calibration Point": calibPoint, "Offset": offXY])
        
    }
    
    
    func getView() -> UIView {
        return self.view
    }
    
    @IBAction func startTraining(_ sender: Any) {
        switch condition {
        case 1:
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Baseline") as? Baseline {
                vc.data = data
                vc.condition = condition
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 2:
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Reachability") as? Reachability {
                vc.data = data
                vc.condition = condition
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 3:
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GazeReachability") as? GazeReachability {
                vc.data = data
                vc.condition = condition
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 4:
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GazeTouch") as? GazeTouch {
                vc.data = data
                vc.condition = condition
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 5:
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComboNormal") as? ComboNormal {
                vc.data = data
                vc.condition = condition
                vc.counter = counter
                
                present(vc, animated: true, completion: nil)
            }
            break
        case 6:
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
