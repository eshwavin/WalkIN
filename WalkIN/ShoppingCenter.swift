//
//  ShoppingCenter.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 23/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class ShoppingCenter: NSObject {
    
    let key: String
    let name: String
    let sdescription: String
    let timings: String
    let address: String
    let contact: String
    let images: Int
    
    init(key: String, name: String, sdescription:String, timings: String, address: String, contact: String, images: Int) {
        
        self.key = key
        self.name = name
        self.sdescription = sdescription
        self.timings = timings
        self.address = address
        self.contact = contact
        self.images = images
        
    }

}
