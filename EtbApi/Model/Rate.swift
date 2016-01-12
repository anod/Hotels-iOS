//
//  Rate.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/23/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

@objc
final class Rate : NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    var rateId: String
    var name: String
    var taxesAndFees = [TaxesAndFees]()
    var payment = Payment()
    var capacity: Int
    //        var description: NSString?
    var rateKey: String?
    var tags = Tags()
    var baseRate = [String:String]()
    var totalNetRate = [String:String]()
    var specialOffers = [SpecialOffers]()
    
    init(rateId: String, response: NSHTTPURLResponse, representation: AnyObject) {
        self.name = representation.valueForKeyPath("name") as! String
        self.rateId = rateId
        self.capacity = Int(representation.valueForKeyPath("capacity") as! String)!
        
        self.payment.prepaid = representation.valueForKeyPath("payment.prepaid") as! [String: String]
        self.payment.postpaid = representation.valueForKeyPath("payment.postpaid") as! [String: String]
        
        self.totalNetRate = representation.valueForKeyPath("totalNetRate") as! [String: String]
    }
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        self.name = representation.valueForKeyPath("name") as! String
        self.rateId = String(representation.valueForKeyPath("rateId"))
        self.rateKey = representation.valueForKeyPath("rateKey") as? String
        self.capacity = representation.valueForKeyPath("capacity") as! Int
        
        self.payment.prepaid = representation.valueForKeyPath("payment.prepaid") as! [String: String]
        self.payment.postpaid = representation.valueForKeyPath("payment.postpaid") as! [String: String]
        
        self.totalNetRate = representation.valueForKeyPath("totalNetRate") as! [String: String]
        
        self.tags.breakfastIncluded = representation.valueForKeyPath("tags.breakfastIncluded") as! Bool
        self.tags.freeCancellation = representation.valueForKeyPath("tags.freeCancellation") as! Bool
        self.tags.nonRefundable = representation.valueForKeyPath("tags.nonRefundable") as! Bool
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Rate] {
        var rates: [Rate] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for rateRepresentation in representation {
                let rate = Rate(response: response, representation: rateRepresentation)
                rates.append(rate)
            }
        }
        
        return rates
    }
    
    class TaxesAndFees {
        var name: String!
        var type: String!
        var totalValue = [String:String]()
    }
    
    class SpecialOffers {
        var type: String?
        var percentage: String?
        var nights: String?
    }
    
    class Payment {
        var prepaid : [String: String]!
        var postpaid : [String :String]!
    }
    
    class Tags {
        var breakfastIncluded = false
        var earlyBird = false
        var freeCancellation = false
        var lastMinute = false
        var nonRefundable = false
    }
}