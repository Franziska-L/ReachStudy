//
//  SCalibration.swift
//  Eyes Tracking
//
//  Created by Borislav Hristov on 23.10.18.
//  Copyright © 2018 virakri. All rights reserved.
//

import Foundation
import UIKit

class SCalibration{
    private static var offset: [CGPoint] = []
    private static var regions: Int = 1
    private static var active: Int = 0
    static var gridX: Int = 0
    static var gridY: Int = 0
    private static var grid: [[CGPoint]]?
    static let screenSize = CGSize(width: 375, height: 812)

    
    /*
     initializes a grid of size (X + 10) x (Y + 10)
     -5 to 0 and X||Y to 5 are used to map the region outside
     the screen with the last ones having size of infinity
     Used for the calculation regarding direction of eye movements
    */
    static func initGrid(x: Int = 3, y: Int = 7){
        SCalibration.gridX = x
        SCalibration.gridY = y
        SCalibration.grid = []
        
        let height = SCalibration.screenSize.height / CGFloat(SCalibration.gridY)
        let width = SCalibration.screenSize.width / CGFloat(SCalibration.gridX)
        
        for h in -5...y+5 {
            for w in -5...x+5 {
                var minX: CGFloat = CGFloat(w) * width
                var maxX: CGFloat = CGFloat(w + 1) * width
                
                var minY = CGFloat(h) * height
                var maxY = CGFloat(h + 1) * height
                
                if w == -5 {
                    minX = -CGFloat.infinity
                } else if w == x+5 {
                    maxX = CGFloat.infinity
                }
                
                if h == -5 {
                    minY = -CGFloat.infinity
                } else if h == y+5 {
                    maxY = CGFloat.infinity
                }
                
                SCalibration.grid?.append([CGPoint(x: minX, y: minY), CGPoint(x: maxX, y: maxY)])
            }
        }
    }
    
    static func getGridRegion(x: CGFloat, y: CGFloat) -> [CGPoint]{
        return SCalibration.getGrid().filter({$0[0].x < x && x < $0[1].x && $0[0].y < y && y < $0[1].y}).first!
    }

    
    /*
     Gets the middle between two points
     if either is +- infinity it returns it
     else it gives the middle between the two
     */
    static func getPointValue(min: CGFloat, max: CGFloat) -> CGFloat {
        if max == CGFloat.infinity {
            return max
        } else if min == -CGFloat.infinity {
            return min
        } else {
            return (max + min) / 2
        }
    }
    
    /*
     For a specific region defined by a point in its top left and another in the
     bottom right corner it gets the center of that region
     */
    static func getRegionMid(region: [CGPoint]) -> CGPoint {
        let min = region[0]
        let max = region[1]

        let midX: CGFloat = SCalibration.getPointValue(min: min.x, max: max.x)
        let midY: CGFloat = SCalibration.getPointValue(min: min.y, max: max.y)

        return CGPoint(x: midX, y: midY)
    }
    
    /*
     Calculates the distance traveled by the eyes in respect to the two regions
     */
    static func getRegionDiff(s: [CGPoint], e: [CGPoint]) -> Int {
        let midS = SCalibration.getRegionMid(region: s)
        let midE = SCalibration.getRegionMid(region: e)
        
        let height = SCalibration.screenSize.height / CGFloat(SCalibration.gridY)
        let width = SCalibration.screenSize.width / CGFloat(SCalibration.gridX)
        
        if abs(midS.x) == CGFloat.infinity || abs(midE.x) == CGFloat.infinity {
            return 10
        }
        
        if abs(midS.y) == CGFloat.infinity || abs(midE.y) == CGFloat.infinity {
            return 10
        }
        
        let x = abs(Int((midS.x - midE.x) / width))
        let y = abs(Int((midS.y - midE.y) / height))
        var d = 0
        
        if x > 0 { d += 1 }
        if y > 0 { d += 1 }

        if d == 0 {
            return 0
        }
        
        return (x + y) / d
    }
    
    /*
     gets the grid of regions,
     each region is defined by a top-left and a bottom-right point
     */
    static func getGrid() -> [[CGPoint]]{
        if SCalibration.grid == nil {
           SCalibration.initGrid()
        }
        
        return SCalibration.grid!
    }

    static func setRegions(_ regions: Int){
        let regions = regions + 1
        self.offset.removeAll()
        self.regions = regions
    }
    
    static func setOffset(_ x: Int, y: Int){
        self.offset.append(CGPoint.init(x: CGFloat(x), y: CGFloat(y)))
    }
    
    static func offsetContinue() -> Bool{
        return SCalibration.offset.count < SCalibration.regions
    }
    
    static func offsetCount() -> Int{
        return SCalibration.offset.count
    }
    
    /*
     Gets the offset for the provided region
     
     */
    static func getOffset(_ region: Int) -> CGPoint{
        if self.offset.count <= region  || region == -1{
            return CGPoint(x: 0, y: 0)
        }
        return self.offset[region]
    }
    
    /*
     Used to clear the calibration data
     */
    static func clear(){
        SCalibration.offset.removeAll()
    }
    
    /*
     used to get the offset/calibration for the position of the tracker
     if no regions and calibration have been setup it returns the original point
     */
    static func getOffsetY(x: CGFloat, y: CGFloat) -> CGPoint{
        let yI = Int(y)
        var region = -1
        
        for i in 0..<SCalibration.regions{
            region = i
            let min = i * Int(SCalibration.screenSize.height) / SCalibration.regions
            let max = (i + 1) * Int(SCalibration.screenSize.height) / SCalibration.regions
            if min < yI && yI < max { break }
        }

        let point = SCalibration.getOffset(region)
        return CGPoint(x: point.x + x, y: point.y + y)
    }
    
    /*
     calculates the eye movement between two regions in 8 directions
     Needs to be optimized to only work with 4 directions
     */
    static func getRegionMovement(s: [CGPoint], e: [CGPoint]) -> String {
        let midS = SCalibration.getRegionMid(region: s)
        let midE = SCalibration.getRegionMid(region: e)
        
        let side = abs(midS.x - midE.x) > abs(midS.y - midE.y)
        
        if midS.x > midE.x && midS.y > midE.y {
            return side ? "ri" : "do"
        } else if midS.x == midE.x && midS.y > midE.y {
            return "down"
        } else if midS.x < midE.x && midS.y > midE.y {
            return side ? "lf" : "do"
        } else if midS.x > midE.x && midS.y == midE.y {
            return "left"
        } else if midS.x == midE.x && midS.y == midE.y {
            return "same"
        } else if midS.x < midE.x && midS.y == midE.y {
            return "right"
        } else if midS.x > midE.x && midS.y < midE.y {
            return side ? "ri" : "up"
        } else if midS.x == midE.x && midS.y < midE.y {
            return "up"
        } else if midS.x < midE.x && midS.y < midE.y {
            return side ? "lf" : "up"
        }
        
        return "0"
    }
    
    static func getRandomDirection() -> String{
        switch Int.random(in: 0 ... 3) {
        case 0:
            return "ri"
        case 1:
            return "lf"
        case 2:
            return "up"
        case 3:
            return "do"
        default:
            return "s"
        }
    }
    
    /*
     Used ot get a random point in a defined region
     As of the moment the region is calculated by the number
     of regions provided for the calibration
     */
    static func topConstraint() -> CGFloat{
        let min: Int = 25 + SCalibration.offsetCount() * Int(SCalibration.screenSize.height) / SCalibration.regions
        let max: Int = 25 + (SCalibration.offsetCount() + 1) * Int(SCalibration.screenSize.height) / SCalibration.regions * 3 / 4
        
        return CGFloat.random(min: CGFloat(min), max: CGFloat(max))
    }
}


