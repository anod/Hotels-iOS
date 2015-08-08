//
//  HotelDetailsAddress.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/1/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class HotelDetailsAddress: UITableViewCell, HotelDetailsViewProtocol  {
    
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func attach(accomodation: Accommodation, rateId: String, availabilityRequest: AvailabilityRequest) {
        var text = accomodation.summary.address as String
        if (!accomodation.summary.city.isEmpty) {
            if (!text.isEmpty) {
                text += ", "
            }
            text += accomodation.summary.city
        }
        if (!accomodation.summary.country.isEmpty) {
            if (!text.isEmpty) {
                text += ", "
            }
            text += accomodation.summary.country
        }
        if (!accomodation.summary.zipcode.isEmpty) {
            if (!text.isEmpty) {
                text += ", "
            }
            text += accomodation.summary.zipcode
        }
        address.text = text
    }
    
}