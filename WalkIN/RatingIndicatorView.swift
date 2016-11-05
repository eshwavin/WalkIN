//
//  RatingIndicatorView.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 12/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class RatingIndicatorView: UIView {

    var percentage: CGFloat = 0.5
    var themeColor: UIColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
        
        let backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
        backgroundColor.setFill()
        let backgroundPath = UIBezierPath(roundedRect: rect, cornerRadius: 1.5)
        backgroundPath.fill()
        
        
        let path = UIBezierPath(roundedRect: CGRect(origin: rect.origin, size: CGSize(width: rect.width * self.percentage, height: rect.height)), cornerRadius: 1.5)
        self.themeColor.set()
        path.fill()
        
    }

}
