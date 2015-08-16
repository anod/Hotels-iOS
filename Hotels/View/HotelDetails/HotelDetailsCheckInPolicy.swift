//
//  HotelDetailsCheckInPolicy.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/1/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class HotelDetailsCheckInPolicy: UITableViewCell, AccommodationViewProtocol  {
    
    @IBOutlet weak var checkInText: UILabel!
    @IBOutlet weak var checkOutText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func attach(accomodation: Accommodation, rateId: String, availabilityRequest: AvailabilityRequest) {
        var checkIn = ""
        if accomodation.details.checkInFrom!.isEmpty == false
        {
            checkIn = accomodation.details.checkInFrom!
        }
        if accomodation.details.checkInUntil!.isEmpty == false
        {
            if (!checkIn.isEmpty) {
                checkIn += " - "
            }
            checkIn += accomodation.details.checkInUntil!
        }
        if (checkIn.isEmpty) {
            checkIn = "-"
        }
        checkInText.text = checkIn
        
        var checkOut = ""
        if accomodation.details.checkOutFrom!.isEmpty == false
        {
            checkOut = accomodation.details.checkOutFrom!
        }
        checkOut += " - "
        if accomodation.details.checkOutUntil!.isEmpty == false
        {
            if (!checkOut.isEmpty) {
                checkOut += " - "
            }
            checkOut += accomodation.details.checkOutUntil!
        }
        if (checkOut.isEmpty) {
            checkOut = "-"
        }
        checkOutText.text = checkOut
        
    }
    
}
