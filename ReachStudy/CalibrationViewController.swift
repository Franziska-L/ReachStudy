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
    
    var eyePositionX: [Int] = [Int]()
    var eyePositionY: [Int] = [Int]()
    
    var skip = 0
    var frames = 0
    
    var offX: [Int] = [Int]()
    var offY: [Int] = [Int]()
    
    var condition: Int?
    var counter: Int = Int()
    var data: Dataset = Dataset()
   
    var ref: DatabaseReference!

    var saveValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(saveValue)

        checkpoint.backgroundColor = UIColor.red
        self.checkpointMiddle.backgroundColor = UIColor(red: 127/255, green: 0, blue: 0, alpha: 1)
        checkpoint.layer.cornerRadius = 25
        
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
            self.checkpointMiddle.backgroundColor = UIColor(red: 127/255, green: 0, blue: 0, alpha: 1)
        } else if self.frames < 100 {
            self.checkpoint.backgroundColor = UIColor.yellow
            self.checkpointMiddle.backgroundColor = UIColor(red: 1, green: 234/255, blue: 48/255, alpha: 1)
        } else if self.frames >= 100 && self.frames < 200 {
            self.checkpoint.backgroundColor = UIColor.green
            self.checkpointMiddle.backgroundColor = UIColor(red: 0, green: 175/255, blue: 5/255, alpha: 1)
            self.adjustXY()
        } else if self.frames == 200 {
            let averageX = self.averageOffset(self.offX)
            let averageY = self.averageOffset(self.offY)
            
            SCalibration.setOffset(averageX, y: averageY)
            
            if saveValue == 1 {
                let averageEyeX = self.averageOffset(self.eyePositionX)
                let averageEyeY = self.averageOffset(self.eyePositionY)
                setOffsetData(estimatedPointX: averageEyeX, estimatedPointY: averageEyeY, offX: averageX, offY: averageY)
                
            }
            
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
        
        self.eyePositionX.append(Int(eyePosition.x))
        self.eyePositionY.append(Int(eyePosition.y))
        
        self.offX.append(Int(self.checkpoint.frame.midX - eyePosition.x))
        self.offY.append(Int(self.checkpoint.frame.midY - eyePosition.y))
    }
    
    func setOffsetData(estimatedPointX: Int, estimatedPointY: Int, offX: Int, offY: Int) {
        
        let estimatedPoint = [estimatedPointX, estimatedPointY]
        let calibPoint = [self.checkpoint.frame.midX, self.checkpoint.frame.midY]
        let offXY = [offX, offY]
     
        ref = Database.database().reference().child("Participant \(data.participantID)").child("Condition \(condition!)")
        ref.updateChildValues(["Estimated Point": estimatedPoint, "Calibration Point": calibPoint, "Offset": offXY])
        
    }
    
    
    func getView() -> UIView {
        return self.view
    }
    
    @IBAction func startTraining(_ sender: Any) {
        if saveValue == 0 {

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
        } else if saveValue == 1 {
            switch condition {
            case 1:
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BaselineTask") as? BaselineTask {
                    vc.data = data
                    vc.condition = condition
                    vc.counter = counter
                    
                    present(vc, animated: true, completion: nil)
                }
                break
            case 2:
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReachTask") as? ReachTask {
                    vc.data = data
                    vc.condition = condition
                    vc.counter = counter
                    
                    present(vc, animated: true, completion: nil)
                }
                break
            case 3:
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GazeReachTask") as? GazeReachTask {
                    vc.data = data
                    vc.condition = condition
                    vc.counter = counter
                    
                    present(vc, animated: true, completion: nil)
                }
                break
            case 4:
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GazeTouchTask") as? GazeTouchTask {
                    vc.data = data
                    vc.condition = condition
                    vc.counter = counter
                    
                    present(vc, animated: true, completion: nil)
                }
                break
            case 5:
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComboNormalTask") as? ComboNormalTask {
                    vc.data = data
                    vc.condition = condition
                    vc.counter = counter
                    
                    present(vc, animated: true, completion: nil)
                }
                break
            case 6:
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComboGazeTask") as? ComboGazeTask {
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
    
    
}
