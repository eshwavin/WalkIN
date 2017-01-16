//
//  SingleStarView.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 08/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class SingleStarView: UIView {

    @IBInspectable var themeColor: UIColor = UIColor.white
    
    
    override func draw(_ rect: CGRect) {
        let dimension = Double(rect.height)
        
        self.themeColor.set()
        let lineWidth = 0.5
        
        let points: [CGPoint] = [CGPoint(x: dimension / 2.0, y: lineWidth),
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
        path.move(to: points.first!)
        
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
        path.fill()
        
    }


}
