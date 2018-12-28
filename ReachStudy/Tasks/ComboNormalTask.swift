//
//  ComboNormalTask.swift
//  ReachStudy
//
//  Created by Franziska Lang on 06.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class ComboNormalTask: GridTargets {
    
    let swipePad: UIView = UIView()
    let swipePadSize: CGFloat = 100
    
    var swipePadX: CGFloat = CGFloat()
    var swipePadY: CGFloat = CGFloat()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipePad.frame = CGRect(x: 0, y: 0, width: swipePadSize, height: swipePadSize)
        swipePad.layer.cornerRadius = CGFloat(swipePadSize / 2)
        swipePad.backgroundColor = UIColor.blue
        swipePad.isHidden = true
        
        self.view.addSubview(swipePad)
        
        borderView.isHidden = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cursor.backgroundColor = UIColor.blue
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        
        let prevLocaiton = touch.previousLocation(in: self.view)
        let newLocation = touch.location(in: self.view)
        
        swipePadX = newLocation.x - (swipePadSize / 2)
        swipePadY = newLocation.y - (swipePadSize / 2)
        
        let distX: CGFloat = newLocation.x - prevLocaiton.x
        let distY: CGFloat = newLocation.y - prevLocaiton.y
        
        let x = swipePadX + distX
        let y = swipePadY + distY - 350.0
        
        swipePad.frame = CGRect(x: swipePadX, y: swipePadY, width: swipePadSize, height: swipePadSize)
        cursor.frame = CGRect(x: x, y: y, width: cursorSize, height: cursorSize)
        
        if swipePad.isHidden {
            swipePad.isHidden = false
            cursor.isHidden = false
        }
    }
    
    @objc func handleTap(sender: UIGestureRecognizer) {
        let position = cursor.frame.origin
        
        if frames <= 7 {
            let isActive = checkPosition(position: position, target: targets[randomNumbers[frames]])
            
            if isActive {
                updateScreen()
            }
        }
    }
    
    override func updateScreen() {
        let number = randomNumbers[frames]
        let currentFrames = frames
        
        targets[number].backgroundColor = UIColor.green
        
        setTimestamp(for: "Touch")
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if currentFrames < 7 {
                
                self.targets[number].backgroundColor = UIColor.gray
                self.targets[self.randomNumbers[currentFrames+1]].backgroundColor = UIColor.yellow
                
                self.setDataTarget()
                
            } else if currentFrames == 7 {
                self.hideViews()
            }
        }
        self.frames += 1
    }
    
    override func activateButton(_ sender: UIButton) {
        let number = randomNumbers[frames]
        let currentFrames = frames
        
        if sender.tag == number && frames <= 7 {
            targets[number].backgroundColor = UIColor.green
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if currentFrames < 7 {
                    
                    self.targets[number].backgroundColor = UIColor.gray
                    self.targets[self.randomNumbers[currentFrames+1]].backgroundColor = UIColor.yellow
                    
                } else if currentFrames == 7 {
                    self.hideViews()
                }
            }
            self.frames += 1
        }
    }
    
    func hideViews() {
        for button in self.targets {
            button.isHidden = true
            self.finishButton.isHidden = false
            self.cursor.isHidden = true
            self.swipePad.isHidden = true
            
            self.timer.invalidate()
            self.setTotalTime()
        }
    }
    
    
}
