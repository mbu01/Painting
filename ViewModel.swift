//
//  ViewModel.swift
//  Painting
//
//  Created by MIN BU on 9/20/16.
//  Copyright © 2016 MIN BU. All rights reserved.
//

import UIKit

class ViewModel {
    
    private var lastPoint = CGPoint.zero
    private var red: CGFloat = 0.0
    private var green: CGFloat = 0.0
    private var blue: CGFloat = 0.0
    private var brushWidth: CGFloat = 10.0
    private var opacity: CGFloat = 1.0
    private var swiped = false

    func getColor(color: String) -> CGFloat {
        switch color {
        case "red":
            return red
        case "green":
            return green
        case "blue":
            return blue
        default: return 0.0
        }
    }

    func getBrushWidth() -> CGFloat {
        return brushWidth
    }
    
    func getOpacity() -> CGFloat {
        return opacity
    }
    
    func isSwiped() -> Bool {
        return swiped
    }
    
    func setSwiped(swipe: Bool) {
        swiped = swipe
    }

    func setLastPoint(last: CGPoint) {
        lastPoint = last
    }
    
    func getLastPoint() -> CGPoint {
        return lastPoint
    }
    
    func brushsliderChanged(brush: CGFloat) {
        brushWidth = brush
    }


}
