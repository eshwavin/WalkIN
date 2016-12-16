//
//  Cab.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 16/12/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class Cab: NSObject {

    let key: String
    let name: String
    let carVariety: String
    let contact: String
    let website: String
    
    init(key: String, name: String, carVariety: String, contact: String, website: String) {
        self.key = key
        self.name = name
        self.carVariety = carVariety
        self.contact = contact
        self.website = website
    }
    
}
