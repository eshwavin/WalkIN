//
//  ShoppingCenterIcon.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 27/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class ShoppingCenterIcon: UIImageView {

    lazy var shoppingCenterIcon: UIImage = self.createImage()
    
    func createImage() -> UIImage {
        let size = CGSize(width: 100, height: 100)
        
        let width: CGFloat = 100
        let height: CGFloat = 100
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        UIColor.white.set()
        
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
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!

    }

}
