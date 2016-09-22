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
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (216.0 / 255.0, 0, 39.0 / 255.0),
        (255.0 / 255.0, 218.0 / 255.0, 68.0 / 255.0),
        (0, 109.0 / 255.0, 240.0 / 255.0),
        (145.0 / 255.0, 220.0 / 255.0, 90.0 / 255.0),
        (1.0, 1.0, 1.0),
        ]
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    @IBOutlet weak var labelBrush: UILabel!
    @IBOutlet weak var sliderBrush: UISlider!
    @IBOutlet weak var titleBrush: UILabel!

    @IBOutlet weak var sizeButton: UIButton!
    
    @IBOutlet weak var colorButton1: UIButton!
    @IBOutlet weak var colorButton2: UIButton!
    @IBOutlet weak var colorButton3: UIButton!
    @IBOutlet weak var colorButton4: UIButton!
    @IBOutlet weak var colorButton5: UIButton!
    @IBOutlet weak var eraseButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sliderBrush.isHidden = true
        labelBrush.isHidden = true
        titleBrush.isHidden = true
        colorButton1.isHidden = true
        colorButton2.isHidden = true
        colorButton3.isHidden = true
        colorButton4.isHidden = true
        colorButton5.isHidden = true
    }

    // MARK: - Actions
    
    
    @IBAction func reset(_ sender: AnyObject) {
        viewModel.reset()
        reloadView()
    }
  
    @IBAction func share(_ sender: AnyObject) {
        let image = viewModel.getMainImage()
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    
    @IBAction func colorPressed(_ sender: AnyObject) {
        if colorButton1.isHidden == true {
            colorButton1.isHidden = false
            colorButton2.isHidden = false
            colorButton3.isHidden = false
            colorButton4.isHidden = false
            colorButton5.isHidden = false
        } else {
            colorButton1.isHidden = true
            colorButton2.isHidden = true
            colorButton3.isHidden = true
            colorButton4.isHidden = true
            colorButton5.isHidden = true
        }
    }
  
    @IBAction func colorSelected(_ sender: AnyObject) {
        var index = sender.tag ?? 0
        if index < 0 || index >= colors.count {
            index = 0
        }
        let color = colors[index]
        viewModel.colorSelect(color: color)

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

