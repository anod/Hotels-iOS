//
//  HotelDetailsReviews.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/19/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class HotelDetailsReviews: UITableViewCell, AccommodationViewProtocol  {
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var reviewsNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func attach(accomodation: Accommodation, rateId: String, availabilityRequest: AvailabilityRequest) {
        
        if accomodation.summary.reviewCount > 0 {
            ratingView.hidden = false
            ratingView.rating = accomodation.summary.reviewScore
            reviewsNumber.text = "\(accomodation.summary.reviewCount) Reviews"
            reviewsNumber.textColor = UIColor.blackColor()
        } else {
            ratingView.hidden = true
            reviewsNumber.text = "No reviews available yet"
            reviewsNumber.textColor = UIColor.grayColor()
        }
    }

}
