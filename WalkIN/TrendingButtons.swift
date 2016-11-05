//
//  TrendingButtons.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 08/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class TrendingButtons: UIButton {

    @IBInspectable var buttonColor: UIColor = UIColor.clear
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        self.buttonColor.set()
        
        switch tag{
        case 1:
            // draw restaurants
            // circle
            let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: width * 1.5 / 10.0, y: height * 0.5 / 10.0), size: CGSize(width: width * 7.0 / 10.0, height: height * 7.0 / 10.0)))
            circlePath.lineWidth = width * 5.0 / 100.0
            circlePath.stroke()
            
            // upper part of fork
            let forkRect1 = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: width * 3.5 / 10.0, y: height * 1.5 / 10.0), size: CGSize(width: width * 0.35 / 10.0, height: height * 2.0 / 10.0)), cornerRadius: width * 0.175 / 10.0)
            forkRect1.fill()
            
            let forkRect2 = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: width * 4.075 / 10.0, y: height * 1.5 / 10.0), size: CGSize(width: width * 0.35 / 10.0, height: height * 2.0 / 10.0)), cornerRadius: width * 0.175 / 10.0)
            forkRect2.fill()
            
            let forkRect3 = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: width * 4.65 / 10.0, y: height * 1.5 / 10.0), size: CGSize(width: width * 0.35 / 10.0, height: height * 2.0 / 10.0)), cornerRadius: width * 0.175 / 10.0)
            forkRect3.fill()
            
            let forkRect4 = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: width * 3.5 / 10.0, y: height * 3.15 / 10.0), size: CGSize(width: width * 1.325 / 10.0, height: height * 0.35 / 10.0)), cornerRadius: width * 0.175 / 10.0)
            forkRect4.fill()
            
            // lower part of the fork
            
            let lowerForkPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: width * 4.050 / 10.0, y: height * 3.15 / 10.0), size: CGSize(width: width * 0.4 / 10.0, height: height * 3.35 / 10.0)), cornerRadius: width * 0.2 / 10.0)
            lowerForkPath.fill()
            
            
            // upper part of knife
            let upperKnifePath = UIBezierPath()
            upperKnifePath.move(to: CGPoint(x: width * 6.5 / 10.0, y: height * 1.5 / 10.0))
            upperKnifePath.addCurve(to: CGPoint(x: width * 5.5 / 10.0, y: height * 4.75 / 10.0), controlPoint1: CGPoint(x: width * 6.0 / 10.0, y: height * 2.5 / 10.0), controlPoint2: CGPoint(x: width * 5.6 / 10.0, y: height * 3.1 / 10.0))
            
            upperKnifePath.addLine(to: CGPoint(x: width * 6.5 / 10.0, y: height * 4.75 / 10.0))
            upperKnifePath.close()
            upperKnifePath.fill()
            
            // lower part of the knife
            let lowerKnifePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: width * 6.1 / 10.0, y: height * 4.5 / 10.0), size: CGSize(width: width * 0.4 / 10.0, height: height * 2.0 / 10.0)), cornerRadius: width * 0.2 / 10.0)
            lowerKnifePath.fill()
            
            
            
        case 2:
            // draw movies
            let moviesOutline = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: width * 2.0 / 10.0, y: height * 0.5 / 10.0), size: CGSize(width: width * 6.0 / 10.0, height: height * 7.0 / 10.0)), cornerRadius: width * 0.5 / 10.0)
            moviesOutline.lineWidth = width * 0.35 / 10.0
            moviesOutline.stroke()
            
            let moviesUpperRect = UIBezierPath(rect: CGRect(origin: CGPoint(x: width * 3.25 / 10.0, y: height * 1.5 / 10.0), size: CGSize(width: width * 3.5 / 10.0, height: height * 2.0 / 10.0)))
            moviesUpperRect.lineWidth = width * 0.35 / 10.0
            moviesUpperRect.stroke()
            
            let moviesLowerRect = UIBezierPath(rect: CGRect(origin: CGPoint(x: width * 3.25 / 10.0, y: height * 4.5 / 10.0), size: CGSize(width: width * 3.5 / 10.0, height: height * 2.0 / 10.0)))
            moviesLowerRect.lineWidth = width * 0.35 / 10.0
            moviesLowerRect.stroke()
            
            let upperFillPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: width * 3.075 / 10.0, y: height * 0.5 / 10.0), size: CGSize(width: width * 3.85 / 10.0, height: height * 1.0 / 10.0)))
            upperFillPath.fill()
            
            let midFillPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: width * 3.075 / 10.0, y: height * 3.5 / 10.0), size: CGSize(width: width * 3.85 / 10.0, height: height * 1.0 / 10.0)))
            midFillPath.fill()
            
            let lowerFillPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: width * 3.075 / 10.0, y: height * 6.5 / 10.0), size: CGSize(width: width * 3.85 / 10.0, height: height * 1.0 / 10.0)))
            lowerFillPath.fill()
            
            
            // squares
            
            let squarePaths = UIBezierPath()
            // left
            squarePaths.move(to: CGPoint(x: width * 2.175 / 10.0, y: height * 1.775 / 10.0))
            squarePaths.addLine(to: CGPoint(x: width * 3.175 / 10.0, y: height * 1.775 / 10.0))
            
            squarePaths.move(to: CGPoint(x: width * 2.175 / 10.0, y: height * 2.92 / 10.0))
            squarePaths.addLine(to: CGPoint(x: width * 3.175 / 10.0, y: height * 2.92 / 10.0))
            
            squarePaths.move(to: CGPoint(x: width * 2.175 / 10.0, y: height * 4.065 / 10.0))
            squarePaths.addLine(to: CGPoint(x: width * 3.175 / 10.0, y: height * 4.065 / 10.0))
            
            squarePaths.move(to: CGPoint(x: width * 2.175 / 10.0, y: height * 5.21 / 10.0))
            squarePaths.addLine(to: CGPoint(x: width * 3.175 / 10.0, y: height * 5.21 / 10.0))
            
            squarePaths.move(to: CGPoint(x: width * 2.175 / 10.0, y: height * 6.355 / 10.0))
            squarePaths.addLine(to: CGPoint(x: width * 3.175 / 10.0, y: height * 6.355 / 10.0))
            
            // right
            
            squarePaths.move(to: CGPoint(x: width * 6.825 / 10.0, y: height * 1.775 / 10.0))
            squarePaths.addLine(to: CGPoint(x: width * 7.825 / 10.0, y: height * 1.775 / 10.0))
            
            squarePaths.move(to: CGPoint(x: width * 6.825 / 10.0, y: height * 2.92 / 10.0))
            squarePaths.addLine(to: CGPoint(x: width * 7.825 / 10.0, y: height * 2.92 / 10.0))
            
            squarePaths.move(to: CGPoint(x: width * 6.825 / 10.0, y: height * 4.065 / 10.0))
            squarePaths.addLine(to: CGPoint(x: width * 7.825 / 10.0, y: height * 4.065 / 10.0))
            
            squarePaths.move(to: CGPoint(x: width * 6.825 / 10.0, y: height * 5.21 / 10.0))
            squarePaths.addLine(to: CGPoint(x: width * 7.825 / 10.0, y: height * 5.21 / 10.0))
            
            squarePaths.move(to: CGPoint(x: width * 6.825 / 10.0, y: height * 6.355 / 10.0))
            squarePaths.addLine(to: CGPoint(x: width * 7.825 / 10.0, y: height * 6.355 / 10.0))
            
            squarePaths.lineWidth = height * 0.29 / 10.0
            squarePaths.stroke()
            
        case 3:
            // draw tourist spots
            let circlePath = UIBezierPath(ovalIn: CGRect(x: width * 4.5 / 10.0, y: height * 2 / 10.0, width: width / 10.0, height: height / 10.0))
            circlePath.fill()
            
            let outerPath = UIBezierPath()
            outerPath.addArc(withCenter: CGPoint(x: width / 2.0, y: height * 2.5 / 10.0), radius: width * 1.5 / 10.0, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI * 2), clockwise: true)
            outerPath.addLine(to: CGPoint(x: width / 2.0, y: height * 5.75 / 10.0))
            outerPath.close()
            
            outerPath.lineWidth = width * 5.0 / 100.0
            outerPath.stroke()
            
            let bottomPath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: width * 4.0 / 10.0, y: height * 6.75 / 10.0), size: CGSize(width: width * 2.0 / 10.0, height: height * 0.5 / 10.0)))
            bottomPath.fill()
            
        case 4:
            // draw shopping centres
            let leftCirclePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: width * 3.5 / 10.0, y: height * 6.0 / 10.0), size: CGSize(width: width / 10.0, height: height / 10.0)))
            leftCirclePath.fill()
            
            let rightCirclePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: width * 5.5 / 10.0, y: height * 6.0 / 10.0), size: CGSize(width: width / 10.0, height: height / 10.0)))
            rightCirclePath.fill()
            
            let shoppingCartPath = UIBezierPath()
            
            shoppingCartPath.move(to: CGPoint(x: width / 10.0, y: height * 1.5 / 10.0))
            shoppingCartPath.addLine(to: CGPoint(x: width * 2.0 / 10.0, y: height * 1.5 / 10.0))
            shoppingCartPath.addLine(to: CGPoint(x: width * 3.0 / 10.0, y: height * 5.5 / 10.0))
            shoppingCartPath.addLine(to: CGPoint(x: width * 7.0 / 10.0, y: height * 5.5 / 10.0))
            shoppingCartPath.addLine(to: CGPoint(x: width * 8.0 / 10.0, y: height * 2.5 / 10.0))
            shoppingCartPath.addLine(to: CGPoint(x: width * 2.25 / 10.0, y: height * 2.5 / 10.0))
            
            shoppingCartPath.lineWidth = width * 5.0 / 100.0
            shoppingCartPath.stroke()
            
            let gridPath = UIBezierPath()
            
            gridPath.move(to: CGPoint(x: width * 4.0 / 10.0, y: height * 2.5 / 10.0))
            gridPath.addLine(to: CGPoint(x: width * 4.0 / 10.0, y: height * 5.5 / 10.0))
            gridPath.move(to: CGPoint(x: width * 6.0 / 10.0, y: height * 2.5 / 10.0))
            gridPath.addLine(to: CGPoint(x: width * 6.0 / 10.0, y: height * 5.5 / 10.0))
            gridPath.move(to: CGPoint(x: width * 2.625 / 10.0, y: height * 4.0 / 10.0))
            gridPath.addLine(to: CGPoint(x: width * 7.5 / 10.0, y: height * 4.0 / 10.0))
            
            gridPath.lineWidth = width * 2.5 / 100.0
            gridPath.stroke()
            
            
            
        default:
            break;
        }
        
        
    }


}
