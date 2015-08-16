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
    var personal: Personal!
    var pyment: Payment!
    var rates: [OrderRate]!
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        self.orderId = Int(representation.valueForKeyPath("orderId") as! String)
        if let ratesJSON: AnyObject = representation.valueForKeyPath("rates") {
            self.rates = OrderRate.collection(response, representation: ratesJSON)
        }
    }
    


    
}