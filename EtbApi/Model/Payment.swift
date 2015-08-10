//
//  Payment.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/10/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class Payment {
    var type: String!
    var data: CreditCardData!
    var billingAddress: Address!
    
    class CreditCardData {
        var ccNr: String!
        var ccCvc: String!
        var ccFirstName: String!
        var ccLastName: String!
        var ccExpiryMonth: Int!
        var ccExpiryYear: Int!
    }
    
    class Address {
        var country: String!
        var state: String!
        var city: String!
        var address: String!
        var postalCode: String!
    }
    
}
