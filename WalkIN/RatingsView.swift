//
//  RatingsView.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 08/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class RatingsView: UIView {

    @IBInspectable var themeColor: UIColor = UIColor.white
    @IBInspectable var rating: Double = 0.0
    
    override func draw(_ rect: CGRect) {
        let dimension = Double(rect.height)
        
        let lineWidth = 0.5
        
        self.themeColor.set()
        
        var points: [CGPoint] = [CGPoint(x: dimension / 2.0, y: lineWidth),
                                 CGPoint(x: dimension * 38.0 / 100.0, y: dimension * 38.0 / 100.0),
                                 CGPoint(x: lineWidth, y: dimension * 39.0 / 100.0),
                                 CGPoint(x: dimension * 31.0 / 100.0, y: dimension * 61.0 / 100.0),
                                 CGPoint(x: dimension * 20.0 / 100.0, y: dimension - lineWidth),
                                 CGPoint(x: dimension * 50.0 / 100.0, y: dimension * 76.0 / 100.0),
                                 CGPoint(x: dimension * 80.0 / 100.0, y: dimension - lineWidth),
                                 CGPoint(x: dimension * 69.0 / 100.0, y: dimension * 61.0 / 100.0),
                                 CGPoint(x: dimension - lineWidth, y: dimension * 39.0 / 100.0),
                                 CGPoint(x: dimension * 62.0 / 100.0, y: dimension * 39.0 / 100.0),
                                 CGPoint(x: dimension / 2.0, y: lineWidth)
        ]
        
        let path = UIBezierPath()
        
        var counter = 0
        while(counter < 5) {
            counter += 1
            
            path.move(to: points.first!)
            let firstPoint = points.first!
            points[0] = CGPoint(x: firstPoint.x + CGFloat(dimension), y: firstPoint.y)
            
            for i in 1..<points.count {
                path.addLine(to: points[i])
                
                let point = points[i]
                points[i] = CGPoint(x: point.x + CGFloat(dimension), y: point.y)
            }
            
        }
        
        path.lineWidth = 1.0
        path.addClip()
        path.stroke()
        
        let fillPath = UIBezierPath(rect: CGRect(origin: rect.origin, size: CGSize(width: dimension * self.rating, height: dimension)))
        fillPath.fill()
        
        
    }


}
