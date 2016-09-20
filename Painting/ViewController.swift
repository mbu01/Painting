//
//  ViewController.swift
//  Painting
//
//  Created by MIN BU on 9/19/16.
//  Copyright © 2016 MIN BU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    
    
    @IBAction func reset(_ sender: AnyObject) {
    }

    
//    @IBAction func share(_ sender: AnyObject) {
//    }
    
    @IBAction func colorPressed(_ sender: AnyObject) {
    }
//    @IBAction func pencilPressed(_ sender: AnyObject) {
//    }
    
    @IBAction func sizePressed(_ sender: AnyObject) {
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        //1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        //2
        context!.move(to: fromPoint)
        context!.addLine(to: toPoint)
        
        //3
        context!.setLineCap(CGLineCap.round)
        context!.setLineWidth(brushWidth)
        context!.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context!.setBlendMode(CGBlendMode.normal)
        
        //4
        context!.strokePath()
        
        //5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //6
        swiped = true
        if let touch = touches.first{
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            //7
            lastPoint = currentPoint
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
        // merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
        super.touchesEnded(touches, with: event)
    }


}

