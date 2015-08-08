//
//  SummaryView.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/8/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import HCSStarRatingView

class SummaryView: UIView, HotelDetailsViewProtocol{
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelAddress: UILabel!
    @IBOutlet weak var hotelStars: HCSStarRatingView!

    @IBOutlet weak var dates: UILabel!
    @IBOutlet weak var nights: UILabel!
    @IBOutlet weak var guests: UILabel!

    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomTags: UILabel!

    @IBOutlet weak var roomPrice: UILabel!
    @IBOutlet weak var taxesAndFees: UILabel!
    @IBOutlet weak var totalPrice: UILabel!

    @IBOutlet weak var payToday: UILabel!
    @IBOutlet weak var payAccomodation: UILabel!
    
    @IBOutlet weak var localCurrencyText: UILabel!
    

    func attach(accomodation: Accommodation, rateId: String, availabilityRequest: AvailabilityRequest) {
        
    }
}