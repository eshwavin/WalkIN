//
//  RestaurantIcon.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 08/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class RestaurantIcon: UIImageView {

    lazy var restaurantIcon: UIImage = self.createImage()
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    func createImage() -> UIImage {
        let size = CGSize(width: 100, height: 100)
        
        let width: CGFloat = 100
        let height: CGFloat = 100
        
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        UIColor.white.set()
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
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }

}
