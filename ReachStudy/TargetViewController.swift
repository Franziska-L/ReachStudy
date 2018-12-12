//
//  TargetViewController.swift
//  ReachStudy
//
//  Created by Franziska Lang on 12.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class TargetViewController: UIViewController, TrackerDelegate {
    
    
    var targets: [UIButton] = [UIButton]()
    var targetPositions: [CGPoint] = [CGPoint]()
    let targetSize: CGSize = CGSize(width: 70, height: 70)
    
    var cursor: UIView = UIView()
    let cursorSize:CGFloat = 10
    
    var randomNumbers = [Int]()
    var frames = 0
    
    var trackerPosition: CGPoint = CGPoint()
    
    var condition: Int?
    var counter: Int = Int()
    var data: Dataset = Dataset()


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        cursor.frame = CGRect(x: 0, y: 0, width: cursorSize, height: cursorSize)
        cursor.layer.cornerRadius = 5
        cursor.backgroundColor = UIColor.red
        
        self.view.addSubview(cursor)
        cursor.isHidden = true
    }
    
    
    func checkPosition(position: CGPoint, target: UIButton) -> Bool {
        let frame = target.frame.origin
        
        let offset: CGFloat = 10.0
        let minX = frame.x - offset
        let minY = frame.y - offset
        let maxX = frame.x + target.frame.width + offset
        let maxY = frame.y + target.frame.height + offset
        
        if position.x > minX && position.x < maxX && position.y > minY && position.y < maxY {
            return true
        } else {
            return false
        }
    }
    
    func setCursorPosition() {
        trackerPosition = EyeTracker.getTrackerPosition()
        
        let x = EyeTracker.instance.trackerView.frame.size.width / 2 + trackerPosition.x
        let y = EyeTracker.instance.trackerView.frame.size.height / 2 + trackerPosition.y
        
        cursor.frame = CGRect(x: x, y: y, width: cursorSize, height: cursorSize)
        cursor.isHidden = false
    }
    
    func getView() -> UIView {
        return self.view
    }
    
    
  
}
