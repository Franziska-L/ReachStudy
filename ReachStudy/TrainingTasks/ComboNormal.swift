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
    
    let cursor: UIView = UIView()
    let cursorSize: CGFloat = 10
    
    var swipePadX: CGFloat = CGFloat()
    var swipePadY: CGFloat = CGFloat()
    
    let middle = 1/2 * UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipePad.frame = CGRect(x: 0, y: 0, width: swipePadSize, height: swipePadSize)
        swipePad.layer.cornerRadius = CGFloat(swipePadSize / 2)
        swipePad.backgroundColor = UIColor.gray
        swipePad.isHidden = true
        
        self.view.addSubview(swipePad)
        
        cursor.frame = CGRect(x: 0, y: 0, width: cursorSize, height: cursorSize)
        cursor.layer.cornerRadius = 5
        cursor.backgroundColor = UIColor.gray
        cursor.isHidden = true
        
        self.view.addSubview(cursor)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tap)
        
    }
    
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     let touch: UITouch! = touches.first
     let currentPosition = touch.location(in: self.view)
     
     swipePadX = currentPosition.x - (swipePadSize / 2)
     swipePadY = currentPosition.y - (swipePadSize / 2)
     swipePad.frame = CGRect(x: swipePadX, y: swipePadY, width: swipePadSize, height: swipePadSize)
     
     let distance: CGFloat = 400
     let x = currentPosition.x - 30.0
     let y = currentPosition.y - distance
     
     cursor.frame = CGRect(x: x, y: y, width: cursorSize, height: cursorSize)
     
     if swipePad.isHidden {
     swipePad.isHidden = false
     cursor.isHidden = false
     }
     }*/
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        
        let prevLocaiton = touch.previousLocation(in: self.view)
        let newLocation = touch.location(in: self.view)
        
        swipePadX = newLocation.x - (swipePadSize / 2)
        swipePadY = newLocation.y - (swipePadSize / 2)
        
        let distX: CGFloat = newLocation.x - prevLocaiton.x
        let distY: CGFloat = newLocation.y - prevLocaiton.y
        
        let x = swipePadX + distX
        let y = swipePadY + distY - 400.0
        
        swipePad.frame = CGRect(x: swipePadX, y: swipePadY, width: swipePadSize, height: swipePadSize)
        cursor.frame = CGRect(x: x, y: y, width: cursorSize, height: cursorSize)
        
        if swipePad.isHidden {
            swipePad.isHidden = false
            cursor.isHidden = false
        }
    }
    
    @objc func handleTap(sender: UIGestureRecognizer) {
        let position = cursor.frame.origin
        
        let offset: CGFloat = 10.0
        
        /*var minX = button1.frame.origin.x - offset
        var minY = button1.frame.origin.y - offset
        var maxX = button1.frame.origin.x + button1.frame.size.width + offset
        var maxY = button1.frame.origin.y + button1.frame.size.height + offset
        
        
        if position.x > minX && position.x < maxX && position.y > minY && position.y < maxY {
            let alert = UIAlertController(title: "Touch recognized", message: "You touched 1. button.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        
        minX = button2.frame.origin.x - offset
        minY = button2.frame.origin.y - offset
        maxX = button2.frame.origin.x + button2.frame.size.width + offset
        maxY = button2.frame.origin.y + button2.frame.size.height + offset
        
        
        if position.x > minX && position.x < maxX && position.y > minY && position.y < maxY {
            let alert = UIAlertController(title: "Touch recognized", message: "You touched 2. button.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }*/
        
    }
    
    @IBAction func click(_ sender: Any) {
        let alert = UIAlertController(title: "Hi", message: "Bla", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}
