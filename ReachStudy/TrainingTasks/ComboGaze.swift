//
//  ComboGaze.swift
//  ReachStudy
//
//  Created by Franziska Lang on 05.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit

class ComboGaze: TrainingTargets {
 
    var isActive1 = false
    var isActive2 = false
    var isActive3 = false
    var isActive4 = false
    
    let middle: CGFloat = 1/2 * UIScreen.main.bounds.height
    
    var dataset = Dataset()
    
    var timer = Timer()
    
    var cursor: UIView = UIView()
    let cursorSize:CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(checkPosition), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cursor.frame = CGRect(x: 0, y: 0, width: cursorSize, height: cursorSize)
        cursor.layer.cornerRadius = 5
        cursor.backgroundColor = UIColor.red
        
        self.view.addSubview(cursor)
        cursor.isHidden = true
    }
    
    func getView() -> UIView {
        return self.view
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let trackerPosition = EyeTracker.getTrackerPosition()
        
        if trackerPosition.y < middle {
            let x = EyeTracker.instance.trackerView.frame.size.width / 2 + trackerPosition.x
            let y = EyeTracker.instance.trackerView.frame.size.height / 2 + trackerPosition.y
            
            cursor.frame = CGRect(x: x, y: y, width: cursorSize, height: cursorSize)
            cursor.isHidden = false
        } else {
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        
        let prevLocaiton = touch.previousLocation(in: self.view)
        let newLocation = touch.location(in: self.view)
        
        let distX: CGFloat = newLocation.x - prevLocaiton.x
        let distY: CGFloat = newLocation.y - prevLocaiton.y
        
        let cursorPosition = cursor.frame.origin
        
        isButtonActive(position: cursorPosition)
        
        
        let x = cursorPosition.x + distX
        let y = cursorPosition.y + distY
        
        cursor.frame = CGRect(x: x, y: y, width: cursorSize, height: cursorSize)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cursor.isHidden = true
        
        let position = cursor.frame.origin
        
        isButtonActive(position: position)
        
        /*if isActive1 {
         let alert = UIAlertController(title: "Touch recognized", message: "You touched 1. button.", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         self.present(alert, animated: true)
         }
         
         if isActive2 {
         let alert = UIAlertController(title: "Touch recognized", message: "You touched 2. button.", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         self.present(alert, animated: true)
         button2.isHighlighted = false
         }
         
         if isActive3 {
         let alert = UIAlertController(title: "Touch recognized", message: "You touched 3. button.", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         self.present(alert, animated: true)
         button3.isHighlighted = false
         }
         
         
         if isActive4 {
         let alert = UIAlertController(title: "Touch recognized", message: "You touched 4. button.", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         self.present(alert, animated: true)
         }*/
    }
    
    @objc func checkPosition() {
        let eyePosition = EyeTracker.getTrackerPosition()
        
        if eyePosition.y < middle {
            EyeTracker.instance.trackerView.backgroundColor = UIColor.red
            EyeTracker.instance.trackerView.alpha = 0.5
        } else {
            EyeTracker.instance.trackerView.alpha = 0.2
            EyeTracker.instance.trackerView.backgroundColor = UIColor.gray
        }
        
        isButtonActive(position: eyePosition)
        
    }
    
    func isButtonActive(position: CGPoint) {
        
        /*let offset: CGFloat = 10.0
         
         var minX = button1.frame.origin.x - offset
         var minY = button1.frame.origin.y - offset
         var maxX = button1.frame.origin.x + button1.frame.size.width + offset
         var maxY = button1.frame.origin.y + button1.frame.size.height + offset
         
         
         if position.x > minX && position.x < maxX && position.y > minY && position.y < maxY {
         isActive1 = true
         button1.isHighlighted = true
         } else {
         isActive1 = false
         button1.isHighlighted = false
         }
         
         
         minX = button2.frame.origin.x - offset
         minY = button2.frame.origin.y - offset
         maxX = button2.frame.origin.x + button2.frame.size.width + offset
         maxY = button2.frame.origin.y + button2.frame.size.height + offset
         
         
         if position.x > minX && position.x < maxX && position.y > minY && position.y < maxY {
         isActive2 = true
         button2.isHighlighted = true
         } else {
         isActive2 = false
         button2.isHighlighted = false
         }
         
         minX = button3.frame.origin.x - offset
         minY = button3.frame.origin.y - offset
         maxX = button3.frame.origin.x + button3.frame.size.width + offset
         maxY = button3.frame.origin.y + button3.frame.size.height + offset
         
         
         if position.x > minX && position.x < maxX && position.y > minY && position.y < maxY {
         isActive3 = true
         button3.isHighlighted = true
         } else {
         isActive3 = false
         button3.isHighlighted = false
         }
         
         minX = button4.frame.origin.x - offset
         minY = button4.frame.origin.y - offset
         maxX = button4.frame.origin.x + button4.frame.size.width + offset
         maxY = button4.frame.origin.y + button4.frame.size.height + offset
         
         
         if position.x > minX && position.x < maxX && position.y > minY && position.y < maxY {
         isActive4 = true
         button4.isHighlighted = true
         } else {
         isActive4 = false
         button4.isHighlighted = false
         }*/
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        let eyePosition = EyeTracker.getTrackerPosition()
        
        if eyePosition.y > middle {
            let tag = sender.tag
            let alert = UIAlertController(title: "Touch recognized", message: "You touched \(tag). button.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
}
