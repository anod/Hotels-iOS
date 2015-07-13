//
//  HodelDetailsHeader.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/12/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import HCSStarRatingView
import Haneke

class HodelDetailsHeader: UITableViewCell {
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelStars: HCSStarRatingView!

    
    func attach(accomodation: Accommodation) {
        
        if (accomodation.images.count > 0) {
            let URL = NSURL(string: accomodation.images[0])!

            hotelImage.hnk_setImageFromURL(URL)
        }
        hotelName.text = accomodation.name
        hotelStars.value = CGFloat(accomodation.starRating)
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
