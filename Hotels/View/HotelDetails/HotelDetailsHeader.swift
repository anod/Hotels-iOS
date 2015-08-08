//
//  HodelDetailsHeader.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/12/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import HCSStarRatingView

class HotelDetailsHeader: UIView, HotelDetailsViewProtocol {
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelStars: HCSStarRatingView!

    static func loadFromNib() -> HotelDetailsHeader {
        return UIView.loadViewFromNib("HotelDetailsHeader", theClass: self) as! HotelDetailsHeader
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func attach(accomodation: Accommodation, rateId: String, availabilityRequest: AvailabilityRequest) {
        
        hotelName.text = accomodation.name
        hotelStars.value = CGFloat(accomodation.starRating)
        
    }
    
}
