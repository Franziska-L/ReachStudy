//
//  Utility.swift
//  ReachStudy
//
//  Created by Franziska Lang on 05.12.18.
//  Copyright © 2018 Franziska Lang. All rights reserved.
//

import Foundation

struct Utility {
    
    func generateRandomSequence(from: Int, to:Int, quit: Int) -> [Int] {
        var randomList = [Int]()
        
        while randomList.count != quit {
            let randomNumber = Int.random(in: from ... to)
            if !randomList.contains(randomNumber) {
                randomList.append(randomNumber)
            }
        }
        return randomList
    }
    
    
    
    func initTimestamp() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd H:m:ss.SSSSSS"
        
        return formatter.string(from: date)
    }
    
    
}
