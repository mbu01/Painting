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
    var count_size = 0

    
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    @IBOutlet weak var labelBrush: UILabel!
    @IBOutlet weak var sliderBrush: UISlider!
    @IBOutlet weak var titleBrush: UILabel!

    @IBOutlet weak var sizeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sliderBrush.isHidden = true
        labelBrush.isHidden = true
        titleBrush.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    
    
    @IBAction func reset(_ sender: AnyObject) {
        mainImageView.image = nil
    }
  
    
    @IBAction func colorPressed(_ sender: AnyObject) {
    }
  
    
    @IBAction func sizePressed(_ sender: AnyObject) {
        count_size += 1
        if count_size % 2 == 1 {
            sliderBrush.isHidden = false
            labelBrush.isHidden = false
            titleBrush.isHidden = false
        } else {
            sliderBrush.isHidden = true
            labelBrush.isHidden = true
            titleBrush.isHidden = true
        }
    }
    
    
    @IBAction func eraserPressed(_ sender: AnyObject) {
    }
  
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        if sender == sliderBrush {
            brushWidth = CGFloat(sender.value)
            labelBrush.text = NSString(format: "%.2f", brushWidth.native) as String
        }
        
        //drawPreview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {

        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        context!.move(to: fromPoint)
        context!.addLine(to: toPoint)
        
        context!.setLineCap(CGLineCap.round)
        context!.setLineWidth(brushWidth)
        context!.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context!.setBlendMode(CGBlendMode.normal)
        
        context!.strokePath()
        
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
        mergeView()
        super.touchesEnded(touches, with: event)
    }
    
    func mergeView() {
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }


}

