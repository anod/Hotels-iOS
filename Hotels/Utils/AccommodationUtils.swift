//
//  AccommodationUtils.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/9/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class AccommodationUtils {
    
    static func findRate(rateId: String, accommodation: Accommodation) -> Rate? {
        var rate: Rate? = nil
        for accRate in accommodation.rates {
            if accRate.rateId == rateId {
                rate = accRate
                break;
            }
        }
        
        return rate
    }
    
    static func findCheapest(accommodation: Accommodation, currencyCode: String) -> Rate? {
        var cheapestRate: Rate? = nil
        for accRate in accommodation.rates {
            if cheapestRate == nil {
                cheapestRate = accRate
            } else if fullPrice(cheapestRate!, currencyCode: currencyCode) > fullPrice(accRate, currencyCode: currencyCode) {
                cheapestRate = accRate
            }
        }
        return cheapestRate
    }
    
    static func fullPrice(rate: Rate, currencyCode: String) -> Double {
        let prepaidPrice = rate.payment.prepaid[currencyCode]!
        let postpaidPrice = rate.payment.postpaid[currencyCode]!
        return prepaidPrice + postpaidPrice;
    }
}