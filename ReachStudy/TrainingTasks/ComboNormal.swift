//
//  ComboNormak.swift
//  ReachStudy
//
//  Created by Franziska Lang on 05.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class ComboNormal: TrainingTargets {
    
    let swipePad: UIView = UIView()
    let swipePadSize: CGFloat = 100
    
    var swipePadX: CGFloat = CGFloat()
    var swipePadY: CGFloat = CGFloat()
    
    var swipePadActive = false
    
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

        if frames < 3 && !checkPosition(position: newLocation, target: targets[randomNumbers[frames]]) {
            swipePadX = newLocation.x - (swipePadSize / 2)
            swipePadY = newLocation.y - (swipePadSize / 2)
            
            let distX: CGFloat = newLocation.x - prevLocaiton.x
            let distY: CGFloat = newLocation.y - prevLocaiton.y
            
            let x = swipePadX + distX + (swipePadSize / 2) - (cursorSize / 2)
            let y = swipePadY + distY - 350.0
            
            swipePad.frame = CGRect(x: swipePadX, y: swipePadY, width: swipePadSize, height: swipePadSize)
            cursor.frame = CGRect(x: x, y: y, width: cursorSize, height: cursorSize)
            
            if frames < 3 && checkPosition(position: CGPoint(x: x, y: y), target: targets[randomNumbers[frames]]) {
                targets[randomNumbers[frames]].backgroundColor = UIColor(red: 255/255, green: 192/255, blue: 91/255, alpha: 1)
            } else if frames < 3 && !checkPosition(position: CGPoint(x: x, y: y), target: targets[randomNumbers[frames]]) {
                targets[randomNumbers[frames]].backgroundColor = UIColor.yellow
            }
            
            if swipePad.isHidden {
                swipePad.isHidden = false
                cursor.isHidden = false
            }
        }
    }
    
    
    @objc func handleTap(sender: UIGestureRecognizer) {
        
        if frames < 3 && targets[randomNumbers[frames]].tag < 2 {
            let position = cursor.frame.origin
            let isActive = checkPosition(position: position, target: targets[randomNumbers[frames]])
            
            if isActive {
                updateScreen()
            }
        } else if frames < 3 && targets[randomNumbers[frames]].tag == 2 {
            let position = sender.location(in: self.view)
            let isActive = checkPosition(position: position, target: targets[randomNumbers[frames]])
            
            if isActive {
                updateScreen()
            }
        }
    }
    
    
    func hideViews() {
        for button in self.targets {
            button.isHidden = true
            self.startTaskButton.isHidden = false
            self.borderView.isHidden = true
            self.cursor.isHidden = true
            self.swipePad.isHidden = true
        }
    }
    
}
