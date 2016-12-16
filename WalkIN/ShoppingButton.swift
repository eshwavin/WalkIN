//
//  ShoppingButton.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 13/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class ShoppingButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        
        let arc = UIBezierPath(arcCenter: CGPoint(x: 0.0 , y: 0.0) , radius: rect.height / 1.3, startAngle: 0.0, endAngle: CGFloat(M_PI_2), clockwise: true)
        arc.lineWidth = rect.width / 30.0
        UIColor(white: 1.0, alpha: 0.5).setStroke()
        UIColor(white: 1.0, alpha: 0.5).setFill()
        arc.stroke()
        
        let arc2 = UIBezierPath(arcCenter: CGPoint(x: 0.0 , y: 0.0) , radius: rect.height / 1.5 , startAngle: 0.0, endAngle: CGFloat(M_PI_2), clockwise: true)
        arc2.lineWidth = rect.width / 28.0
        arc2.stroke()
        
        let width = rect.height / 2.0
        let height = width
        
        // draw shopping centres
        let leftCirclePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: width * 3.5 / 10.0, y: height * 7.0 / 10.0), size: CGSize(width: width / 10.0, height: height / 10.0)))
        leftCirclePath.fill()
        
        let rightCirclePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: width * 5.5 / 10.0, y: height * 7.0 / 10.0), size: CGSize(width: width / 10.0, height: height / 10.0)))
        rightCirclePath.fill()
        
        let shoppingCartPath = UIBezierPath()
        
        shoppingCartPath.move(to: CGPoint(x: width / 10.0, y: height * 2.5 / 10.0))
        shoppingCartPath.addLine(to: CGPoint(x: width * 2.0 / 10.0, y: height * 2.5 / 10.0))
        shoppingCartPath.addLine(to: CGPoint(x: width * 3.0 / 10.0, y: height * 6.5 / 10.0))
        shoppingCartPath.addLine(to: CGPoint(x: width * 7.0 / 10.0, y: height * 6.5 / 10.0))
        shoppingCartPath.addLine(to: CGPoint(x: width * 8.0 / 10.0, y: height * 3.5 / 10.0))
        shoppingCartPath.addLine(to: CGPoint(x: width * 2.25 / 10.0, y: height * 3.5 / 10.0))
        
        shoppingCartPath.lineWidth = width * 5.0 / 100.0
        shoppingCartPath.stroke()
        
        let gridPath = UIBezierPath()
        
        gridPath.move(to: CGPoint(x: width * 4.0 / 10.0, y: height * 3.5 / 10.0))
        gridPath.addLine(to: CGPoint(x: width * 4.0 / 10.0, y: height * 6.5 / 10.0))
        gridPath.move(to: CGPoint(x: width * 6.0 / 10.0, y: height * 3.5 / 10.0))
        gridPath.addLine(to: CGPoint(x: width * 6.0 / 10.0, y: height * 6.5 / 10.0))
        gridPath.move(to: CGPoint(x: width * 2.625 / 10.0, y: height * 5.0 / 10.0))
        gridPath.addLine(to: CGPoint(x: width * 7.5 / 10.0, y: height * 5.0 / 10.0))
        
        gridPath.lineWidth = width * 2.5 / 100.0
        gridPath.stroke()

        
    }

}
