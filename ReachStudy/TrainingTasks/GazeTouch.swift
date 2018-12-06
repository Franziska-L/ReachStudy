//
//  GazeTouch.swift
//  ReachStudy
//
//  Created by Franziska Lang on 05.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import UIKit


class GazeTouch: GazeBasedController {
    
    let cursorSize:CGFloat = 10
    var cursor: UIView = UIView()
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cursor.frame = CGRect(x: 0, y: 0, width: cursorSize, height: cursorSize)
        cursor.layer.cornerRadius = 5
        cursor.backgroundColor = UIColor.red
        
        self.view.addSubview(cursor)
        cursor.isHidden = true
    }
    
    
    
    func showCursor(cursor: UIView) -> CGRect{
        trackerPosition = EyeTracker.getTrackerPosition()
        
        let x = EyeTracker.instance.trackerView.frame.size.width / 2 + trackerPosition.x
        let y = EyeTracker.instance.trackerView.frame.size.height / 2 + trackerPosition.y
        
        cursor.frame = CGRect(x: x, y: y, width: 10, height: 10)
        cursor.isHidden = false
        
        return cursor.frame
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Show Cursor
        trackerPosition = EyeTracker.getTrackerPosition()
        
        let x = EyeTracker.instance.trackerView.frame.size.width / 2 + trackerPosition.x
        let y = EyeTracker.instance.trackerView.frame.size.height / 2 + trackerPosition.y
        
        cursor.frame = CGRect(x: x, y: y, width: cursorSize, height: cursorSize)
        cursor.isHidden = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        
        let prevLocaiton = touch.previousLocation(in: self.view)
        let newLocation = touch.location(in: self.view)
        
        let distX: CGFloat = newLocation.x - prevLocaiton.x
        let distY: CGFloat = newLocation.y - prevLocaiton.y
        
        let cursorPosition = cursor.frame.origin
        
        let x = cursorPosition.x + distX
        let y = cursorPosition.y + distY
        
        cursor.frame = CGRect(x: x, y: y, width: cursorSize, height: cursorSize)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cursor.isHidden = true
        
        let position = cursor.frame.origin
        
       
    }
}
