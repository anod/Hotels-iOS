//
//  AccommodationRender.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/9/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class AccommodationRender {
    
    static func address(accomodation: Accommodation) -> String {
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
        return text
    }
    
    static func rateTags(rate: Rate) -> String {
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
        return tags;
    }
}