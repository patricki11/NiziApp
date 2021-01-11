//
//  CircularProgressView.swift
//  NiziApp
//
//  Created by Patrick Dammers on 11/12/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import Foundation
import UIKit

class CircularProgressView: UIView {

    // First create two layer properties
private var circleLayer = CAShapeLayer()
private var progressLayer = CAShapeLayer()
private var totalLabel = CATextLayer()
  
    private var greenColor : CGColor = UIColor(red: 0x86, green: 0xCD, blue: 0x96).cgColor
    private var yellowColor : CGColor = UIColor(red: 0xD1, green: 0xBD, blue: 0x76).cgColor
    private var redColor : CGColor = UIColor(red: 0xCE, green: 0x88, blue: 0x87).cgColor
    private var grayColor : CGColor = UIColor.systemGray.cgColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 40, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 8.0
        circleLayer.strokeColor = grayColor
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 8.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = grayColor
        totalLabel.alignmentMode = .center
        totalLabel.fontSize = 14
        totalLabel.foregroundColor = UIColor.black.cgColor
        totalLabel.frame = CGRect(x: (frame.size.width / 2) - 30, y: (frame.size.height / 2) - 10, width: 60, height: 50)
        totalLabel.string = "0"
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
        layer.addSublayer(totalLabel)
    }
    
    func progressAnimation(guideline: NewDietaryManagement, weightUnit: newWeightUnit?, currentTotal: Int) {
        
        var toValue : Double = 0.0
        let min = Double(guideline.minimum ?? 0)
        let max = Double(guideline.maximum ?? 0)
        let total = Double(currentTotal)

        let unit = weightUnit?.short ?? ""
        totalLabel.string = "\(String(currentTotal)) \(unit)"
        
        if(min != 0) {
            circleLayer.strokeColor = yellowColor
        }
        else if(max != 0) {
            circleLayer.strokeColor = greenColor
        }
        
        if(currentTotal != 0) {
           
            if(min != 0 && max != 0) {
                toValue = total / min
                if(total < min) {
                    circleLayer.strokeColor = yellowColor
                    progressLayer.strokeColor = greenColor
                }
                else if(total >= min && total <= max) {
                    circleLayer.strokeColor = grayColor
                    progressLayer.strokeColor = greenColor
                }
                else if(total > max) {
                    circleLayer.strokeColor = grayColor
                    progressLayer.strokeColor = redColor
                }
            }
            else if(min != 0) {
                toValue = total / min
                if(total >= min) {
                    circleLayer.strokeColor = grayColor
                    progressLayer.strokeColor = greenColor
                }
                else if(total < min) {
                    circleLayer.strokeColor = yellowColor
                    progressLayer.strokeColor = greenColor
                }
            }
            else if(max != 0) {
                toValue = total / max
                if(total <= max) {
                    circleLayer.strokeColor = grayColor
                    progressLayer.strokeColor = greenColor
                }
                else if(total > max) {
                    circleLayer.strokeColor = grayColor
                    progressLayer.strokeColor = redColor
                }
            }
        }

        if(toValue > 1) {
            toValue = 1
        }
        
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = 1
        circularProgressAnimation.toValue = toValue
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    
}




