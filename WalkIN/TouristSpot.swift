//
//  TouristSpot.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 28/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class TouristSpot: NSObject {
    
    let key: String
    let name: String
    let tdescription: String
    let timings: String
    let entryFree: String
    let address: String
    let dosAndDonts: String
    let images: Int
    
    init(key: String, name: String, tdescription: String, timings: String, entryFee: String, address: String, dosAndDonts: String, images: Int) {
        
        self.key = key
        self.name = name
        self.tdescription = tdescription
        self.timings = timings
        self.address = address
        self.entryFree = entryFee
        self.dosAndDonts = dosAndDonts
        self.images = images
        
    }
    
}
