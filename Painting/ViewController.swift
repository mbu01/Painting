//
//  ViewController.swift
//  Painting
//
//  Created by MIN BU on 9/19/16.
//  Copyright © 2016 MIN BU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = ViewModel()
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    @IBOutlet weak var labelBrush: UILabel!
    @IBOutlet weak var sliderBrush: UISlider!
    @IBOutlet weak var titleBrush: UILabel!

    @IBOutlet weak var sizeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sliderBrush.isHidden = true
        labelBrush.isHidden = true
        titleBrush.isHidden = true
    }

    // MARK: - Actions
    
    
    @IBAction func reset(_ sender: AnyObject) {
        mainImageView.image = nil
    }
  
    
    @IBAction func colorPressed(_ sender: AnyObject) {
    }
  
    
    @IBAction func sizePressed(_ sender: AnyObject) {
        
        if sliderBrush.isHidden == true {
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
            viewModel.brushsliderChanged(brush: CGFloat(sender.value))
            labelBrush.text = NSString(format: "%.2f", viewModel.getBrushWidth().native) as String
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.setSwiped(swipe: false)
        if let touch = touches.first {
            viewModel.setLastPoint(last: touch.location(in: self.view))
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {

        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        context!.move(to: fromPoint)
        context!.addLine(to: toPoint)
        
        context!.setLineCap(CGLineCap.round)
        context!.setLineWidth(viewModel.getBrushWidth())
        context!.setStrokeColor(red: viewModel.getColor(color: "red"), green: viewModel.getColor(color: "green"), blue: viewModel.getColor(color: "blue"), alpha: 1.0)
        context!.setBlendMode(CGBlendMode.normal)
        
        context!.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = viewModel.getOpacity()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        viewModel.setSwiped(swipe: true)
        if let touch = touches.first{
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: viewModel.getLastPoint(), toPoint: currentPoint)
            viewModel.setLastPoint(last: currentPoint)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !viewModel.isSwiped() {
            drawLineFrom(fromPoint: viewModel.getLastPoint(), toPoint: viewModel.getLastPoint())
        }

        mergeView()
    }
    
    func mergeView() {
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: viewModel.getOpacity())
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }


}

