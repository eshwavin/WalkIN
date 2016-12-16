//
//  MovieTheatre.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 22/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class MovieTheatre: NSObject {

    let key: String
    let name: String
    let contact: String
    let address: String
    let ac_non: Bool
    
    init(key: String, name: String, contact: String, address: String, ac_non: String) {
    
        self.key = key
        self.name = name
        self.contact = contact
        self.address = address
        
        if ac_non == "y" {
            self.ac_non = true
        }
        else {
            self.ac_non = false
        }
        
        
    }
    
    
}
