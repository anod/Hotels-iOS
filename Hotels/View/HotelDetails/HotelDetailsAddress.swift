//
//  HotelDetailsAddress.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/1/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class HotelDetailsAddress: UITableViewCell, AccommodationViewProtocol  {
    
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func attach(accomodation: Accommodation, rateId: String, availabilityRequest: AvailabilityRequest) {

        address.text = AccommodationRender.address(accomodation)
    }
    

}