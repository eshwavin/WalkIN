//
//  MovieTheatreDetailsTableViewCell.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 22/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class MovieTheatreDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
