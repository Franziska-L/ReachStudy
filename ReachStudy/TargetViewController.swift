//
//  TargetViewController.swift
//  ReachStudy
//
//  Created by Franziska Lang on 12.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class TargetViewController: UIViewController, TrackerDelegate {
    
    
    var targets: [UIView] = [UIView]()
    var targetPositions: [CGPoint] = [CGPoint]()
    let targetSize: CGSize = CGSize(width: 70, height: 70)
    
    var cursor: UIView = UIView()
    let cursorSize:CGFloat = 12
    
    var randomNumbers = [Int]()
    var frames = 0
    
    var borderView = UIView()
    let middle: CGFloat = 1/2 * UIScreen.main.bounds.height
    var viewIsMoved: Bool = false
    let moveDistance: CGFloat = 350


    
    var trackerPosition: CGPoint = CGPoint()
    
    var condition: Int?
    var counter: Int = Int()
    var data: Dataset = Dataset()


    override func viewDidLoad() {
        super.viewDidLoad()

        borderView.frame = CGRect(x: 0, y: middle, width: view.frame.width, height: 2)
        borderView.backgroundColor = UIColor.black
        self.view.addSubview(borderView)
        borderView.isHidden = true
        
        if condition == 3 || condition == 2 {
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
            swipeUp.direction = .up
            self.view.addGestureRecognizer(swipeUp)
            
            if condition == 2 {
                let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
                swipeDown.direction = .down
                self.view.addGestureRecognizer(swipeDown)
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        cursor.frame = CGRect(x: 0, y: 0, width: cursorSize, height: cursorSize)
        cursor.layer.cornerRadius = cursorSize/2
        cursor.backgroundColor = UIColor.red
        
        self.view.addSubview(cursor)
        cursor.isHidden = true
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            if viewIsMoved {
                UIView.animate(withDuration: 0.4) {
                    self.view.frame.origin.y -= self.moveDistance
                }
                viewIsMoved = false
            }
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            if !viewIsMoved {
                self.view.layer.cornerRadius = 40
                UIView.animate(withDuration: 0.4) {
                    self.view.frame.origin.y += self.moveDistance
                }
                
                viewIsMoved = true
            }
        }
    }
    
    func checkPosition(position: CGPoint, target: UIView) -> Bool {
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
    
    func setCursorPosition(position: CGPoint) {
        
        let x = EyeTracker.instance.trackerView.frame.size.width / 2 + position.x - cursorSize/2
        let y = EyeTracker.instance.trackerView.frame.size.height / 2 + position.y - cursorSize/2
        
        cursor.frame = CGRect(x: x, y: y, width: cursorSize, height: cursorSize)
        cursor.isHidden = false
    }
    
    func getView() -> UIView {
        return self.view
    }
    
    
  
}
