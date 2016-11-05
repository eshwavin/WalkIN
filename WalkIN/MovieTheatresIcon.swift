//
//  MovieTheatresIcon.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 22/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class MovieTheatresIcon: UIImageView {

    lazy var movieTheatreIcon: UIImage = self.createImage()
    
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
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }

}
