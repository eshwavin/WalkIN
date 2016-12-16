//
//  CabsButton.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 28/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class CabsButton: UIButton {

    
    override func draw(_ rect: CGRect) {
        
        let arc = UIBezierPath(arcCenter: CGPoint(x: rect.width , y: 0.0) , radius: rect.height / 1.2, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI), clockwise: true)
        arc.lineWidth = rect.width / 30.0
        UIColor(white: 1.0, alpha: 0.5).setStroke()
        UIColor(white: 1.0, alpha: 0.5).setFill()
        arc.stroke()
        
        let arc2 = UIBezierPath(arcCenter: CGPoint(x: rect.width , y: 0.0) , radius: rect.height / 1.4, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI), clockwise: true)
        arc2.lineWidth = rect.width / 28.0
        arc2.stroke()
        
        let width = rect.height / 2.0
        let height = width
        
        let shiftWidth = rect.width - (width * 11.0 / 10.0)
        
        // draw upper rectangle
        
        let upperRectanglePath = UIBezierPath(roundedRect: CGRect(x: shiftWidth + width * 4 / 10.0, y: height * 1.0 / 10.0, width: width * 2.0 / 10.0, height: height * 1.0 / 10.0), cornerRadius: width * 0.5 / 10.0)
        upperRectanglePath.fill()
        
        // draw upper part of cab
        let upperCabPath = UIBezierPath()
        upperCabPath.move(to: CGPoint(x: shiftWidth + width * 2.0 / 10.0, y: height * 5.0 / 10.0))
        upperCabPath.addCurve(to: CGPoint(x: shiftWidth + width * 5.0 / 10.0, y: height * 2.0 / 10.0), controlPoint1: CGPoint(x: shiftWidth + width * 2.75 / 10.0, y: height * 3.0 / 10.0), controlPoint2: CGPoint(x: shiftWidth + width * 3.0 / 10.0, y: height * 2.0 / 10.0))
        
        upperCabPath.addCurve(to: CGPoint(x: shiftWidth + width * 8.0 / 10.0, y: height * 5.0 / 10.0), controlPoint1: CGPoint(x: shiftWidth + width * 7.0 / 10.0, y: height * 2.0 / 10.0), controlPoint2: CGPoint(x: shiftWidth + width * 7.25 / 10.0, y: height * 3.0 / 10.0))
        
        upperCabPath.lineWidth = width * 0.5 / 10.0
        upperCabPath.stroke()
        
        // set clip paths
        let circleClipPath1 = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: shiftWidth + width * 2.0 / 10.0, y: height * 5.5 / 10.0), size: CGSize(width: width * 1.0 / 10.0, height: height * 1.0 / 10.0)))
        
        let circleClipPath2 = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: shiftWidth + width * 7.0 / 10.0, y: height * 5.5 / 10.0), size: CGSize(width: width * 1.0 / 10.0, height: height * 1.0 / 10.0)))
        
        circleClipPath1.append(circleClipPath2)
        
        // bottom cab path
        
        let bottomCabRect = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: shiftWidth + width * 1.5 / 10.0, y: height * 4.5 / 10.0), size: CGSize(width: width * 7.0 / 10.0, height: height * 3.0 / 10.0)), cornerRadius: width * 0.5 / 10.0)
        
        bottomCabRect.append(circleClipPath1)
        bottomCabRect.usesEvenOddFillRule = true
        bottomCabRect.fill()
        
        // wheels path
        
        let wheelsPath1 = UIBezierPath(roundedRect:  CGRect(origin: CGPoint(x: shiftWidth + width * 2.0 / 10.0, y: height * 7.5 / 10.0), size: CGSize(width: width * 1.0 / 10.0, height: height * 1.25 / 10.0)), byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: width * 0.25 / 10.0, height: width * 0.25 / 10.0))
        
        wheelsPath1.fill()
        
        let wheelsPath2 = UIBezierPath(roundedRect:  CGRect(origin: CGPoint(x: shiftWidth + width * 7.0 / 10.0, y: height * 7.5 / 10.0), size: CGSize(width: width * 1.0 / 10.0, height: height * 1.25 / 10.0)), byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: width * 0.25 / 10.0, height: width * 0.25 / 10.0))
        
        wheelsPath2.fill()

        
    }
    

}
