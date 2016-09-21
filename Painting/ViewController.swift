//
//  ViewController.swift
//  Painting
//
//  Created by MIN BU on 9/19/16.
//  Copyright © 2016 MIN BU. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
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
        viewModel.reset()
        reloadView()
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
        
        if let touch = touches.first {
            viewModel.touchesBegin(firstTouch: true, touchPoint: touch.location(in: self.view))
        } else {
            viewModel.touchesBegin(firstTouch: false, touchPoint: CGPoint.zero)
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first{
            viewModel.touchesMove(firstTouch: true, touchPoint: touch.location(in: view), tempImageSize: tempImageView.frame.size)
            
        } else {
            viewModel.touchesMove(firstTouch: false, touchPoint: CGPoint.zero, tempImageSize: tempImageView.frame.size)
        }
        reloadView()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.touchesEnd(tempFrameSize: tempImageView.frame.size, mainFrameSize: mainImageView.frame.size)
        reloadView()
    }

    func reloadView() {
        tempImageView.image = viewModel.getTempImage()
        mainImageView.image = viewModel.getMainImage()
    }
}

