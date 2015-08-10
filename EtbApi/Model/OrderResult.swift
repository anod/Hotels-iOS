//
//  OrderResult.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/10/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class OrderResult : NSObject, ResponseObjectSerializable {
    
    var meta:Meta!
    var order:Order?
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        if let metaJSON: AnyObject = representation.valueForKeyPath("meta") {
            self.meta = Meta(response: response, representation: metaJSON)
        }
        if let orderJSON: AnyObject = representation.valueForKeyPath("order") {
            self.order = Order(response: response, representation: orderJSON)
        }
    }
}