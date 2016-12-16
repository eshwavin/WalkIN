//
//  Bus.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 08/12/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class Bus: NSObject {
    
    let key: String
    let name: String
    let boardingPoint: String
    let busType: String
    let departureTime: String
    let destination: String
    
    init(key: String, name: String, boardingPoint: String, busType: String, departureTime: String, destination: String) {
        
        self.key = key
        self.name = name
        self.boardingPoint = boardingPoint
        self.busType = busType
        self.departureTime = departureTime
        self.destination = destination
        
    }
    
}
