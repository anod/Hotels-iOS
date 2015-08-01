//
//  DetailsRequest.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/1/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class AvailabilityRequest {
    
    var checkInDate = NSDate()
    var checkOutDate = NSDate(timeIntervalSinceNow: 86400)
    var currency = "EUR"
    var language = "en"
    var capacity = [String]()

    
    func prepareCapacityForRequest() -> String{
        var newCapacity = ""
        
        if !capacity.isEmpty {
            for (var index = 0; index < capacity.count ; index++){
                newCapacity = index == 0 ? newCapacity + capacity[index] : newCapacity + "," + capacity[index]
            }
        }
        else{
            newCapacity = "2"
        }
        
        return newCapacity
    }
}