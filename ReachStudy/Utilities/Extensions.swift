//
//  Extensions.swift
//  EyeTracking
//
//  Created by Franziska Lang on 01.11.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//
//
//  SCNVectorExtension.swift
//  Face-based Game Prototype
//
//  Created by VIRAKRI JINANGKUL on 10/31/17.
//  Copyright © 2017 VIRAKRI JINANGKUL. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
}

func - (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(l.x - r.x, l.y - r.y, l.z - r.z)
}

extension Collection where Element == CGFloat, Index == Int {
    /// Return the mean of a list of CGFloat. Used with `recentVirtualObjectDistances`.
    var average: CGFloat? {
        guard !isEmpty else {
            return nil
        }
        
        let sum = reduce(CGFloat(0)) { current, next -> CGFloat in
            return current + next
        }
        
        return sum / CGFloat(count)
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
