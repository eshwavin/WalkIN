//
//  TrainsButton.swift
//  
//
//  Created by Srivinayak Chaitanya Eshwa on 28/10/16.
//
//

import UIKit

class TrainsButton: UIButton {

    
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
        
        // main train path
        let mainTrainPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: shiftWidth + width * 2.0 / 10.0, y: height * 1.0 / 10.0), size: CGSize(width: width * 6.0 / 10.0, height: height * 6.0 / 10.0)), cornerRadius: width * 1.25 / 10.0)
        
        // upper rect cut out
        let upperRect = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: shiftWidth + width * 4.0 / 10.0, y: height * 1.75 / 10.0), size: CGSize(width: width * 2.0 / 10.0, height: height * 0.5 / 10.0)), cornerRadius: width * 0.25 / 10.0)
        
        let middleRect = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: shiftWidth + width * 2.75 / 10.0, y: height * 2.75 / 10.0), size: CGSize(width: width * 4.5 / 10.0, height: height * 1.75 / 10.0)), cornerRadius: width * 0.45 / 10.0)
        
        
        let circleClipPath1 = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: shiftWidth + width * 3.0 / 10.0, y: height * 5.0 / 10.0), size: CGSize(width: width * 1.0 / 10.0, height: height * 1.0 / 10.0)))
        
        let circleClipPath2 = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: shiftWidth + width * 6.0 / 10.0, y: height * 5.0 / 10.0), size: CGSize(width: width * 1.0 / 10.0, height: height * 1.0 / 10.0)))
        
        mainTrainPath.append(upperRect)
        mainTrainPath.append(middleRect)
        mainTrainPath.append(circleClipPath1)
        mainTrainPath.append(circleClipPath2)
        
        mainTrainPath.usesEvenOddFillRule = true
        
        mainTrainPath.fill()
        
        // track
        let trackPath = UIBezierPath()
        trackPath.move(to: CGPoint(x: shiftWidth + width * 4.0 / 10.0, y: height * 7.0 / 10.0))
        
        trackPath.addLine(to: CGPoint(x: shiftWidth + width * 2.0 / 10.0, y: height * 9.0 / 10.0))
        
        trackPath.addLine(to: CGPoint(x: shiftWidth + width * 8.0 / 10.0, y: height * 9.0 / 10.0))
        
        trackPath.addLine(to: CGPoint(x: shiftWidth + width * 6.0 / 10.0, y: height * 7.0 / 10.0))
        
        trackPath.move(to: CGPoint(x: shiftWidth + width * 3.0 / 10.0, y: height * 8.0 / 10.0))
        
        trackPath.addLine(to: CGPoint(x: shiftWidth + width * 7.0 / 10.0, y: height * 8.0 / 10.0))
        
        trackPath.lineWidth = width * 3.0 / 100
        trackPath.stroke()
    
    }
    

}
