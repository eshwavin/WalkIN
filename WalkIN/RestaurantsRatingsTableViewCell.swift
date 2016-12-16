//
//  RestaurantsRatingsTableViewCell.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 12/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class RestaurantsRatingsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ratingHeading5: RatingsView!
    @IBOutlet weak var ratingHeading4: RatingsView!
    @IBOutlet weak var ratingHeading3: RatingsView!
    @IBOutlet weak var ratingHeading2: RatingsView!
    @IBOutlet weak var ratingHeading1: RatingsView!
    
    @IBOutlet weak var ratingIndicator5: RatingIndicatorView!
    @IBOutlet weak var ratingIndicator4: RatingIndicatorView!
    @IBOutlet weak var ratingIndicator3: RatingIndicatorView!
    @IBOutlet weak var ratingIndicator2: RatingIndicatorView!
    @IBOutlet weak var ratingIndicator1: RatingIndicatorView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var starView: SingleStarView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var userRating: RatingsView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
