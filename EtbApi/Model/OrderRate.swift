//
//  OrderRate.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/16/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

@objc
final class OrderRate: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {

    var statusCode: String!
    var confirmationId: String!
    var password: String!

    var rateCount: Int!
    
    var request: AvailabilityRequest!
    var rate: Rate!
    var accommodation: Accommodation!
    var created: NSDate!
    var charge = Charge()
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        let accommodationId = Int(representation.valueForKeyPath("accommodationId") as! String)
        if let accommodationJSON: AnyObject = representation.valueForKeyPath("accommodation") {
            self.accommodation = Accommodation(id: accommodationId!, response: response, representation: accommodationJSON)
        }
        
        self.statusCode = representation.valueForKeyPath("statusCode") as! String
        self.confirmationId = representation.valueForKeyPath("confirmationId") as! String
        self.password = representation.valueForKeyPath("password") as! String
        self.rateCount = representation.valueForKeyPath("rateCount") as! Int
        
        let checkIn = representation.valueForKeyPath("checkIn") as! String
        let checkOut = representation.valueForKeyPath("checkOut") as! String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.request = AvailabilityRequest()
        self.request.checkInDate = dateFormatter.dateFromString(checkIn)!
        self.request.checkOutDate = dateFormatter.dateFromString(checkOut)!
        let capacity = Int(representation.valueForKeyPath("capacity") as! String)!
        self.request.capacity = [capacity]
        self.request.currency = representation.valueForKeyPath("charge.currency") as! String
        
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        let created = representation.valueForKeyPath("created") as! String
        self.created = dateFormatter.dateFromString(created)!
        
        self.charge.currency = representation.valueForKeyPath("charge.currency") as! String
        self.charge.paymentType = representation.valueForKeyPath("charge.paymentType") as! String
        self.charge.totalChargeable = representation.valueForKeyPath("charge.totalChargeable") as! String
        
        // Fix type issues
        let rateId = String(representation.valueForKeyPath("rateId") as! String) 
        self.rate = Rate(rateId: rateId, response: response, representation: representation)
        if self.accommodation != nil {
            self.accommodation.postpaidCurrency = self.charge.currency
            self.accommodation.rates.append(self.rate)
        }
    }
    
    static func collection(response: NSHTTPURLResponse, representation: AnyObject) -> [OrderRate] {
        var rates: [OrderRate] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for rateRepresentation in representation {
                let rate = OrderRate(response: response, representation: rateRepresentation)
                rates.append(rate)
            }
        }
        
        return rates
    }
    
    class Charge {
        var currency: String!
        var paymentType: String!
        var totalChargeable: String!
    }
}