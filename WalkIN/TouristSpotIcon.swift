//
//  TouristSpotIcon.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 28/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class TouristSpotIcon: UIImageView {

    lazy var touristSpotIcon: UIImage = self.createImage()
    
    func createImage() -> UIImage {
        
        let size = CGSize(width: 100, height: 100)
        
        let width: CGFloat = 100
        let height: CGFloat = 100
        
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        UIColor.white.set()
        
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
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!

        
    }

}
