//
//  ViewModel.swift
//  Painting
//
//  Created by MIN BU on 9/20/16.
//  Copyright © 2016 MIN BU. All rights reserved.
//

import UIKit

class ViewModel {
    
    private var lastPoint: CGPoint = CGPoint.zero
    private var red: CGFloat = 0.0
    private var green: CGFloat = 0.0
    private var blue: CGFloat = 0.0
    private var brushWidth: CGFloat = 10.0
    private var opacity: CGFloat = 1.0
    private var swiped: Bool = false
    private var mainImage: UIImage? = nil
    private var tempImage: UIImage? = nil
    
    
    func getBrushWidth() -> CGFloat {
        return brushWidth
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
    
    func reset() {
        mainImage = nil
        tempImage = nil
    }
    
    func touchesBegin(firstTouch: Bool, touchPoint: CGPoint) {
        swiped = false
        if firstTouch {
            lastPoint = touchPoint
        }
    }
    
    func touchesMove(firstTouch: Bool, touchPoint: CGPoint, tempImageSize: CGSize) {
        swiped = true
        if firstTouch{
            let currentPoint = touchPoint
            tempImage = drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint, frameSize: tempImageSize)
            lastPoint = currentPoint
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint, frameSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(frameSize)
        let context = UIGraphicsGetCurrentContext()
        tempImage?.draw(in: CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height))
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(getBrushWidth())
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        context?.strokePath()
        
        tempImage = UIGraphicsGetImageFromCurrentImageContext()
        //tempImage.alpha = opacity
        UIGraphicsEndImageContext()
        return tempImage
    }

    func touchesEnd(tempFrameSize: CGSize, mainFrameSize: CGSize) {
        if !swiped {
            tempImage = drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint, frameSize: tempFrameSize)
        }
        mergeView(mainFrameSize: mainFrameSize)
    }
    
    func mergeView(mainFrameSize:CGSize) {
        UIGraphicsBeginImageContext(mainFrameSize)
        mainImage?.draw(in: CGRect(x: 0, y: 0, width: mainFrameSize.width, height: mainFrameSize.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        tempImage?.draw(in: CGRect(x: 0, y: 0, width: mainFrameSize.width, height: mainFrameSize.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImage = nil
    }
    
    func getTempImage() -> UIImage? {
        return tempImage
    }
    
    func getMainImage() -> UIImage? {
        return mainImage
    }

}
