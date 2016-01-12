//
//  Order.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/10/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class Order: NSObject, ResponseObjectSerializable {
    var orderId: Int!
    var pyment: Payment!
    var rates: [OrderRate]!
    var personal = Personal()

    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        self.orderId = Int(representation.valueForKeyPath("orderId") as! String)
        if let ratesJSON: AnyObject = representation.valueForKeyPath("rates") {
            self.rates = OrderRate.collection(response: response, representation: ratesJSON)
        }
        
        self.personal.firstName = representation.valueForKeyPath("personal.firstName") as! String
        self.personal.lastName = representation.valueForKeyPath("personal.lastName") as! String
        self.personal.email = representation.valueForKeyPath("personal.email") as! String
        self.personal.country = representation.valueForKeyPath("personal.country") as! String
        self.personal.phone = representation.valueForKeyPath("personal.phone") as! String
    }
    


    
}