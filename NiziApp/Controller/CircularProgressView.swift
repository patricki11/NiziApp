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
        circleLayer.lineWidth = 12.0
        circleLayer.strokeColor = UIColor.lightGray.cgColor
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 12.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.lightGray.cgColor
        totalLabel.alignmentMode = .center
        totalLabel.fontSize = 20
        totalLabel.foregroundColor = UIColor.black.cgColor
        totalLabel.frame = CGRect(x: (frame.size.width / 2) - 20, y: (frame.size.height / 2) - 10, width: 40, height: 40)
        totalLabel.string = "0"
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
        layer.addSublayer(totalLabel)
    }
    
    func progressAnimation(minimum: Int?, maximum: Int?, currentTotal: Int) {
        
        var toValue : Double = 0.0
        let min = Double(minimum ?? 0)
        let max = Double(maximum ?? 0)
        let total = Double(currentTotal)
        totalLabel.string = String(currentTotal)
        
        if(min != 0) {
            circleLayer.strokeColor = UIColor.yellow.cgColor
        }
        else if(max != 0) {
            circleLayer.strokeColor = UIColor.green.cgColor
        }
        
        if(currentTotal != 0) {
           
            if(min != 0 && max != 0) {
                toValue = total / min
                if(total < min) {
                    circleLayer.strokeColor = UIColor.yellow.cgColor
                    progressLayer.strokeColor = UIColor.green.cgColor
                }
                else if(total >= min && total <= max) {
                    circleLayer.strokeColor = UIColor.lightGray.cgColor
                    progressLayer.strokeColor = UIColor.green.cgColor
                }
                else if(total > max) {
                    circleLayer.strokeColor = UIColor.lightGray.cgColor
                    progressLayer.strokeColor = UIColor.red.cgColor
                }
            }
            else if(min != 0) {
                toValue = total / min
                if(total >= min) {
                    circleLayer.strokeColor = UIColor.lightGray.cgColor
                    progressLayer.strokeColor = UIColor.green.cgColor
                }
                else if(total < min) {
                    circleLayer.strokeColor = UIColor.yellow.cgColor
                    progressLayer.strokeColor = UIColor.green.cgColor
                }
            }
            else if(max != 0) {
                var toValue = total / max
                if(total <= max) {
                    circleLayer.strokeColor = UIColor.green.cgColor
                    progressLayer.strokeColor = UIColor.yellow.cgColor
                }
                else if(total > max) {
                    circleLayer.strokeColor = UIColor.lightGray.cgColor
                    progressLayer.strokeColor = UIColor.red.cgColor
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
