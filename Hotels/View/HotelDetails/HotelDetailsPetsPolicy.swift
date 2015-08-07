//
//  HotelDetailsPetsPolicy.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/1/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class HotelDetailsPetsPolicy: UITableViewCell, HotelDetailsViewProtocol  {
    
    @IBOutlet weak var policy: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    /*
    petsAllowed integer
        0: not allowed
        1: allowed
        2: dogs only
    petsAllowedOnRequest
        boolean	If true, pets are allowed on request
    petsSurcharge integer
        0: no surcharge
        1: surcharge
        2: deposit
        -1: unknown
    */
    func attach(accomodation: Accommodation, availaibilityRequest: AvailabilityRequest) {
        if (accomodation.details.petsPolicy.petsAllowed == 0) {
            policy.text = "Pets are not allowed."
            return
        } else {
            var text: String
            if (accomodation.details.petsPolicy.petsAllowed == 2) {
                text = "Only dogs are allowed."
            } else {
                text = "Pets are allowed."
            }
            if (accomodation.details.petsPolicy.petsAllowedOnRequest) {
                text += " Only upon request."
            }
            if (accomodation.details.petsPolicy.petsSurcharge == 1) {
                text += " Surcharge required"
            }
            if (accomodation.details.petsPolicy.petsSurcharge == 2) {
                text += " Deposit required"
            }
            policy.text = text
        }
        
    }
    
}