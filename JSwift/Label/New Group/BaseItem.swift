//
//  BaseItem.swift
//  JSwift
//
//  Created by jps on 2021/5/17.
//

import Foundation
import UIKit

class BaseItem {
    var clickableFrames: [CGRect] = []
    var clicked: ((Any) -> Void)?
    
    
    func addFrame(_ frame: CGRect) {
        clickableFrames.append(frame)
    }
    
    func containsPoint(_ point: CGPoint) -> Bool {
        let isContain = clickableFrames.contains { (rect) -> Bool in
            return rect.contains(point)
        }
        return isContain
    }
}



