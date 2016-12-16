//
//  BusIcon.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 15/12/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class CabIcon: UIImageView {
    
    lazy var cabIcon: UIImage = self.createImage()
    
    func createImage() -> UIImage {
        let size = CGSize(width: 100, height: 100)
        
        let width: CGFloat = 100
        let height: CGFloat = 100
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        UIColor.white.set()
        
        // draw upper rectangle
        
        let upperRectanglePath = UIBezierPath(roundedRect: CGRect(x: width * 4 / 10.0, y: height * 1.0 / 10.0, width: width * 2.0 / 10.0, height: height * 1.0 / 10.0), cornerRadius: width * 0.5 / 10.0)
        upperRectanglePath.fill()
        
        // draw upper part of cab
        let upperCabPath = UIBezierPath()
        upperCabPath.move(to: CGPoint(x: width * 2.0 / 10.0, y: height * 5.0 / 10.0))
        upperCabPath.addCurve(to: CGPoint(x: width * 5.0 / 10.0, y: height * 2.0 / 10.0), controlPoint1: CGPoint(x: width * 2.75 / 10.0, y: height * 3.0 / 10.0), controlPoint2: CGPoint(x: width * 3.0 / 10.0, y: height * 2.0 / 10.0))
        
        upperCabPath.addCurve(to: CGPoint(x: width * 8.0 / 10.0, y: height * 5.0 / 10.0), controlPoint1: CGPoint(x: width * 7.0 / 10.0, y: height * 2.0 / 10.0), controlPoint2: CGPoint(x: width * 7.25 / 10.0, y: height * 3.0 / 10.0))
        
        upperCabPath.lineWidth = width * 0.5 / 10.0
        upperCabPath.stroke()
        
        // set clip paths
        let circleClipPath1 = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: width * 2.0 / 10.0, y: height * 5.5 / 10.0), size: CGSize(width: width * 1.0 / 10.0, height: height * 1.0 / 10.0)))
        
        let circleClipPath2 = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: width * 7.0 / 10.0, y: height * 5.5 / 10.0), size: CGSize(width: width * 1.0 / 10.0, height: height * 1.0 / 10.0)))
        
        circleClipPath1.append(circleClipPath2)
        
        // bottom cab path
        
        let bottomCabRect = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: width * 1.5 / 10.0, y: height * 4.5 / 10.0), size: CGSize(width: width * 7.0 / 10.0, height: height * 3.0 / 10.0)), cornerRadius: width * 0.5 / 10.0)
        
        bottomCabRect.append(circleClipPath1)
        bottomCabRect.usesEvenOddFillRule = true
        bottomCabRect.fill()
        
        // wheels path
        
        let wheelsPath1 = UIBezierPath(roundedRect:  CGRect(origin: CGPoint(x: width * 2.0 / 10.0, y: height * 7.5 / 10.0), size: CGSize(width: width * 1.0 / 10.0, height: height * 1.25 / 10.0)), byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: width * 0.25 / 10.0, height: width * 0.25 / 10.0))
        
        wheelsPath1.fill()
        
        let wheelsPath2 = UIBezierPath(roundedRect:  CGRect(origin: CGPoint(x: width * 7.0 / 10.0, y: height * 7.5 / 10.0), size: CGSize(width: width * 1.0 / 10.0, height: height * 1.25 / 10.0)), byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: width * 0.25 / 10.0, height: width * 0.25 / 10.0))
        
        wheelsPath2.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
    
    
}
