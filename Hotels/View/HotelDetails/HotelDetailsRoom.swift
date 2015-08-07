//
//  HotelDetailsReviews.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/19/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class HotelDetailsRoom: UITableViewCell, HotelDetailsViewProtocol  {
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomPrice: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var policy: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func attach(accomodation: Accommodation, availaibilityRequest: AvailabilityRequest) {
        
        let rate = accomodation.rates[0]
        let priceRender = PriceRender(currencyCode: availaibilityRequest.currency, short: false)

        roomPrice.text = priceRender.render(rate)
        roomName.text = rate.name
        
        var tags = ""
        if rate.tags.nonRefundable {
            tags = "Non-Refundable"
        } else if (rate.tags.freeCancellation) {
            tags = "Free Cancelation"
        }
        if (rate.tags.breakfastIncluded) {
            if !tags.isEmpty {
                tags += " "
            }
            tags += "Breakfast Included"
        }
        
        policy.text = tags
    }

}
