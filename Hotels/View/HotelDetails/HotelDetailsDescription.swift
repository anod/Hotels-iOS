//
//  HotelDetailsReviews.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/19/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class HotelDetailsDescription: UITableViewCell, AccommodationViewProtocol  {

    @IBOutlet weak var hotelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func attach(accomodation: Accommodation, rateId: String, availabilityRequest: AvailabilityRequest) {
        if let descr = accomodation.details.generalDescription {
            hotelDescription.setHtml(descr)
        }
        hotelDescription.sizeToFit()
        self.sizeToFit()
    }

}
