//
//  AccommodationViewProtocol.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/16/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

protocol AccommodationViewProtocol {
    
    func attach(accomodation: Accommodation, rateId: String, availabilityRequest: AvailabilityRequest)
}