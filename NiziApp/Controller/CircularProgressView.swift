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
        circleLayer.lineWidth = 15.0
        circleLayer.strokeColor = UIColor.black.cgColor
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 9.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.red.cgColor
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }
    
    func progressAnimation(minimum: Int?, maximum: Int?, currentTotal: Int) {
        
        var toValue : Double = 0.0
        let min = Double(minimum!)
        let max = Double(maximum!)
        let total = Double(currentTotal)
        if(currentTotal != 0) {
           
            if(minimum != 0 && maximum != 0) {
                toValue = min / max
                if(currentTotal < minimum!) {
                    progressLayer.strokeColor = UIColor.yellow.cgColor
                }
                else if(currentTotal >= minimum! && currentTotal <= maximum!) {
                    progressLayer.strokeColor = UIColor.green.cgColor
                }
                else if(currentTotal > maximum!) {
                    progressLayer.strokeColor = UIColor.red.cgColor
                }
            }
            else if(minimum != 0) {
                toValue = total / min
                if(currentTotal >= minimum!) {
                    progressLayer.strokeColor = UIColor.green.cgColor
                }
                else if(currentTotal < minimum!) {
                    progressLayer.strokeColor = UIColor.red.cgColor
                }
            }
            else if(maximum != 0) {
                var toValue = total / max
                if(currentTotal <= maximum!) {
                    progressLayer.strokeColor = UIColor.green.cgColor
                }
                else if(currentTotal > maximum!) {
                    progressLayer.strokeColor = UIColor.red.cgColor
                }
            }
        }

        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = 1
        circularProgressAnimation.toValue = toValue
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
