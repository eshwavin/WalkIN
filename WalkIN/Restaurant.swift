//
//  Restaurant.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 08/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class Restaurant: NSObject {

    var id: String
    var rid: Int
    var name: String
    var timings: String
    var contact:String
    var address: String
    var speciality: String
    var rdescription: String
    var weblink: String
    var homeDelivery: Bool
    var no5: Int
    var no4: Int
    var no3: Int
    var no2: Int
    var no1: Int
    var rating: Float
    var images: Int
    
    init(id: String, rid: Int, name: String, timings: String, contact: String, address: String, speciality: String, rdescription: String, weblink: String, homeDelivery: Bool, no5: Int, no4: Int, no3: Int, no2: Int, no1: Int, rating: Float, images: Int = 0) {
        self.id = id
        self.rid = rid
        self.name = name
        self.timings = timings
        self.contact = contact
        self.address = address
        self.speciality = speciality
        self.rdescription = rdescription
        self.weblink = weblink
        self.homeDelivery = homeDelivery
        self.no5 = no5
        self.no4 = no4
        self.no3 = no3
        self.no2 = no2
        self.no1 = no1
        self.rating = rating
        self.images = images
    }
    
    func returnRestaurantDictionary() -> [String: AnyObject] {
        let dictionary = ["id": self.id, "rid" : self.rid, "name" : self.name, "timings" : self.timings, "contact": self.contact, "address" : self.address, "speciality": self.speciality, "description": self.rdescription, "weblink": self.weblink, "home_delivery": self.homeDelivery, "no5": self.no5, "no4": self.no4, "no3": self.no3, "no2": self.no2, "no1": self.no1] as [String : Any]
        return dictionary as [String: AnyObject]
    }

    
}

