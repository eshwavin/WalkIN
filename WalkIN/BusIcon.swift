//
//  BusIcon.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 15/12/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class BusIcon: UIImageView {
    
    lazy var busIcon: UIImage = self.createImage()

    func createImage() -> UIImage {
        let size = CGSize(width: 100, height: 100)
        
        let width: CGFloat = 100
        let height: CGFloat = 100
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        UIColor.white.set()
        
        let outerRectPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: width * 1.5 / 10.0, y: height * 1.0 / 10.0), size: CGSize(width: width * 7.0 / 10.0, height: height * 7.0 / 10.0)), cornerRadius: width * 0.25 / 10.0)
        
        let upperRect = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: width * 3.5 / 10.0, y: height * 1.5 / 10.0), size: CGSize(width: width * 3.0 / 10.0, height: height * 0.75 / 10.0)), cornerRadius: width * 0.20 / 10.0)
        
        let middleRect = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: width * 2.0 / 10.0, y: height * 2.75 / 10.0), size: CGSize(width: width * 6.0 / 10.0, height: height * 3.0 / 10.0)), cornerRadius: width * 0.25 / 10.0)
        
        let circleClipPath1 = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: width * 2.0 / 10.0, y: height * 6.0 / 10.0), size: CGSize(width: width * 1.0 / 10.0, height: height * 1.0 / 10.0)))
        
        let circleClipPath2 = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: width * 7.0 / 10.0, y: height * 6.0 / 10.0), size: CGSize(width: width * 1.0 / 10.0, height: height * 1.0 / 10.0)))
        
        let bottomRect = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: width * 4.0 / 10.0, y: height * 7 / 10.0), size: CGSize(width: width * 2.0 / 10.0, height: height * 0.5 / 10.0)), cornerRadius: width * 0.20 / 10.0)
        
        outerRectPath.append(upperRect)
        outerRectPath.append(middleRect)
        outerRectPath.append(circleClipPath2)
        outerRectPath.append(circleClipPath1)
        outerRectPath.append(bottomRect)
        
        outerRectPath.usesEvenOddFillRule = true
        outerRectPath.fill()
        
        // wheels
        let wheelsPath1 = UIBezierPath(roundedRect:  CGRect(origin: CGPoint(x: width * 2.0 / 10.0, y: height * 8.0 / 10.0), size: CGSize(width: width * 1.0 / 10.0, height: height * 1.0 / 10.0)), byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: width * 0.25 / 10.0, height: width * 0.25 / 10.0))
        
        wheelsPath1.fill()
        
        let wheelsPath2 = UIBezierPath(roundedRect:  CGRect(origin: CGPoint(x: width * 7.0 / 10.0, y: height * 8.0 / 10.0), size: CGSize(width: width * 1.0 / 10.0, height: height * 1.0 / 10.0)), byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: width * 0.25 / 10.0, height: width * 0.25 / 10.0))
        
        wheelsPath2.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }


}
