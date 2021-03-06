//
//  DetailsRequest.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/1/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class AvailabilityRequest {
    
    var checkInDate = NSDate(timeIntervalSinceNow: 86400)
    var checkOutDate = NSDate(timeIntervalSinceNow: 2*86400)
    var currency = "EUR"
    var language = "en"
    var capacity = [2]

    
    func prepareCapacityForRequest() -> String{
        var newCapacity = ""
        
        for (var index = 0; index < capacity.count ; index++){
            newCapacity = index == 0 ? newCapacity + String(capacity[index]) : newCapacity + "," + String(capacity[index])
        }
        
        return newCapacity
    }
    
    func persons() -> Int {
        return capacity.reduce(0, combine: +)
    }
}