//
//  HotelDetailsReviews.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/19/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class HotelDetailsRoom: UITableViewCell, AccommodationViewProtocol  {
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomPrice: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var policy: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bookButton.userInteractionEnabled = false
    }


    func attach(accomodation: Accommodation, rateId: String, availabilityRequest: AvailabilityRequest) {
        
        let currencyCode = availabilityRequest.currency;
        
        var rate: Rate!
        for accRate in accomodation.rates {
            if accRate.rateId == rateId {
                rate = accRate
                break;
            }
        }
        
        if rate == nil {
            print("rate \(rateId) not found")
            return;
        }
        
        if rate.rateKey != nil {
            bookButton.userInteractionEnabled = true
        }
        let priceRender = PriceRender(currencyCode: currencyCode, short: false)

        roomPrice.text = priceRender.render(rate)
        roomName.text = rate.name
        
        policy.text = AccommodationRender.rateTags(rate)
    }

}
