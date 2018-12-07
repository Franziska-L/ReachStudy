//
//  TrainingTargets.swift
//  ReachStudy
//
//  Created by Franziska Lang on 05.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//


import UIKit

class TrainingTargets: UIViewController {
  
    
    //var trackerPosition: CGPoint = CGPoint()
    
    var trainingTargets: [UIButton] = [UIButton]()
    var targetPositions: [CGPoint] = [CGPoint]()
    let targetSize: CGSize = CGSize(width: 70, height: 70)
    //var isTargetActive = false
    
    var condition: Int?
    var counter: Int = Int()
    var data: Dataset = Dataset()
    
    var randomNumbers = [Int]()
    
    var frames = 0
    //var timer = Timer()
    
    //var cursor: UIView = UIView()

    

    var startTaskButton: UIButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTaskButton.frame = CGRect(x: 100, y: 500, width: 200, height: 60)
        startTaskButton.setTitle("Starte Training", for: .normal)
        startTaskButton.setTitleColor(UIColor.blue, for: .normal)
        startTaskButton.addTarget(self, action: #selector(startTask), for: .touchUpInside)
        self.view.addSubview(startTaskButton)
        
        startTaskButton.isHidden = true
        
        randomNumbers = Utility().generateRandomSequence(from: 0, to: 2, quit: 3)
        
        let x1: CGFloat = 50
        let x2: CGFloat = 170
        let x3: CGFloat = 300
        let y1: CGFloat = 100
        let y2: CGFloat = 300
        let y3: CGFloat = 500
        
        targetPositions = [
            CGPoint(x: x1, y: y1),
            CGPoint(x: x2, y: y2),
            CGPoint(x: x3, y: y3)]
        
        for index in 0...targetPositions.count-1 {
            let target: UIButton = UIButton()
            target.frame = CGRect(origin: targetPositions[index], size: targetSize)
            target.backgroundColor = UIColor.gray
            target.layer.cornerRadius = targetSize.width / 2
            target.tag = index
            if condition == 1 {
                target.addTarget(self, action: #selector(activateButton), for: .touchUpInside)
            }

            self.view.addSubview(target)
            trainingTargets.append(target)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.frames == 0 {
                self.trainingTargets[self.randomNumbers[self.frames]].backgroundColor = UIColor.yellow
            }
        }
        
        //timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updateScreen), userInfo: nil, repeats: true)
    }
    
    
    @objc func activateButton(_ sender: UIButton) {}
    @objc func startTask() {}
    
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(condition!)
        switch condition {
        case 4:
            //Gazebased indirect touch
            GazeTouch().showCursor(cursor: cursor)
            break
        default:
            break
        }
    }*/
    
  
    
    /*@objc func updateScreen() {
        if frames < 3 {
            //self.trainingTargets[randomNumbers[frames]-1].backgroundColor = UIColor.gray
            self.trainingTargets[randomNumbers[frames]].backgroundColor = UIColor.yellow
            frames += 1
        } else if frames == 3 {
            for button in trainingTargets {
                button.isHidden = true
                startTask.isHidden = false
            }
        }
    }*/
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startTask" {
            if let vc = segue.destination as? GridTargets {
                vc.condition = condition
                vc.data = data
                vc.counter = counter
            }
        }
    }*/

    
}
