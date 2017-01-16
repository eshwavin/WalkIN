//
//  RatingIndicatorView.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 12/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class RatingIndicatorView: UIView {

    @IBInspectable var themeColor: UIColor = UIColor.white
    var percentage: CGFloat = 0.5
    
    override func draw(_ rect: CGRect) {
        
        let backgroundColor = UIColor(red: 192.0/255.0, green: 188.0/255.0, blue: 188.0/255.0, alpha: 1.0)
        backgroundColor.setFill()
        let backgroundPath = UIBezierPath(roundedRect: rect, cornerRadius: 1.5)
        backgroundPath.fill()
        
        
        let path = UIBezierPath(roundedRect: CGRect(origin: rect.origin, size: CGSize(width: rect.width * self.percentage, height: rect.height)), cornerRadius: 1.5)
        self.themeColor.set()
        path.fill()
        
    }

}
