//
//  MovieTheatresButton.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 21/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class MovieTheatresButton: UIButton {

    
    override func draw(_ rect: CGRect) {
        
        let arc = UIBezierPath(arcCenter: CGPoint(x: rect.width , y: 0.0) , radius: rect.width / 2.0, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: true)
        arc.lineWidth = rect.width / 30.0
        UIColor(white: 1.0, alpha: 0.5).setStroke()
        UIColor(white: 1.0, alpha: 0.5).setFill()
        arc.stroke()
        
        let arc2 = UIBezierPath(arcCenter: CGPoint(x: rect.width , y: 0.0) , radius: (rect.width * 17.0 / 30.0), startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: true)
        arc2.lineWidth = rect.width / 28.0
        arc2.stroke()
        
        let width = rect.height / 2.0
        let height = width
        
        let shiftWidth = rect.width * 1.8 / 2.8
        
        // draw movies
        let moviesOutline = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: shiftWidth + width * 2.0 / 10.0, y: height * 1.5 / 10.0), size: CGSize(width: width * 6.0 / 10.0, height: height * 7.0 / 10.0)), cornerRadius: width * 0.5 / 10.0)
        moviesOutline.lineWidth = width * 0.35 / 10.0
        moviesOutline.stroke()
        
        let moviesUpperRect = UIBezierPath(rect: CGRect(origin: CGPoint(x: shiftWidth + width * 3.25 / 10.0, y: height * 2.5 / 10.0), size: CGSize(width: width * 3.5 / 10.0, height: height * 2.0 / 10.0)))
        moviesUpperRect.lineWidth = width * 0.35 / 10.0
        moviesUpperRect.stroke()
        
        let moviesLowerRect = UIBezierPath(rect: CGRect(origin: CGPoint(x: shiftWidth + width * 3.25 / 10.0, y: height * 5.5 / 10.0), size: CGSize(width: width * 3.5 / 10.0, height: height * 2.0 / 10.0)))
        moviesLowerRect.lineWidth = width * 0.35 / 10.0
        moviesLowerRect.stroke()
        
        let upperFillPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: shiftWidth + width * 3.075 / 10.0, y: height * 1.675 / 10.0), size: CGSize(width: width * 3.85 / 10.0, height: height * 0.65 / 10.0)))
        upperFillPath.fill()
        
        let midFillPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: shiftWidth + width * 3.075 / 10.0, y: height * 4.675 / 10.0), size: CGSize(width: width * 3.85 / 10.0, height: height * 0.65 / 10.0)))
        midFillPath.fill()
        
        let lowerFillPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: shiftWidth + width * 3.075 / 10.0, y: height * 7.675 / 10.0), size: CGSize(width: width * 3.85 / 10.0, height: height * 0.65 / 10.0)))
        lowerFillPath.fill()
        
        // squares
        
        let squarePaths = UIBezierPath()
        // left
        squarePaths.move(to: CGPoint(x: shiftWidth + width * 2.175 / 10.0, y: height * 2.775 / 10.0))
        squarePaths.addLine(to: CGPoint(x: shiftWidth + width * 3.075 / 10.0, y: height * 2.775 / 10.0))
        
        squarePaths.move(to: CGPoint(x: shiftWidth + width * 2.175 / 10.0, y: height * 3.92 / 10.0))
        squarePaths.addLine(to: CGPoint(x: shiftWidth + width * 3.075 / 10.0, y: height * 3.92 / 10.0))
        
        squarePaths.move(to: CGPoint(x: shiftWidth + width * 2.175 / 10.0, y: height * 5.065 / 10.0))
        squarePaths.addLine(to: CGPoint(x: shiftWidth + width * 3.075 / 10.0, y: height * 5.065 / 10.0))
        
        squarePaths.move(to: CGPoint(x: shiftWidth + width * 2.175 / 10.0, y: height * 6.21 / 10.0))
        squarePaths.addLine(to: CGPoint(x: shiftWidth + width * 3.075 / 10.0, y: height * 6.21 / 10.0))
        
        squarePaths.move(to: CGPoint(x: shiftWidth + width * 2.175 / 10.0, y: height * 7.355 / 10.0))
        squarePaths.addLine(to: CGPoint(x: shiftWidth + width * 3.075 / 10.0, y: height * 7.355 / 10.0))
        
        // right
        
        squarePaths.move(to: CGPoint(x: shiftWidth + width * 6.925 / 10.0, y: height * 2.775 / 10.0))
        squarePaths.addLine(to: CGPoint(x: shiftWidth + width * 7.825 / 10.0, y: height * 2.775 / 10.0))
        
        squarePaths.move(to: CGPoint(x: shiftWidth + width * 6.925 / 10.0, y: height * 3.92 / 10.0))
        squarePaths.addLine(to: CGPoint(x: shiftWidth + width * 7.825 / 10.0, y: height * 3.92 / 10.0))
        
        squarePaths.move(to: CGPoint(x: shiftWidth + width * 6.925 / 10.0, y: height * 5.065 / 10.0))
        squarePaths.addLine(to: CGPoint(x: shiftWidth + width * 7.825 / 10.0, y: height * 5.065 / 10.0))
        
        squarePaths.move(to: CGPoint(x: shiftWidth + width * 6.925 / 10.0, y: height * 6.21 / 10.0))
        squarePaths.addLine(to: CGPoint(x: shiftWidth + width * 7.825 / 10.0, y: height * 6.21 / 10.0))
        
        squarePaths.move(to: CGPoint(x: shiftWidth + width * 6.925 / 10.0, y: height * 7.355 / 10.0))
        squarePaths.addLine(to: CGPoint(x: shiftWidth + width * 7.825 / 10.0, y: height * 7.355 / 10.0))
        
        squarePaths.lineWidth = height * 0.29 / 10.0
        squarePaths.stroke()

    }
    

}
