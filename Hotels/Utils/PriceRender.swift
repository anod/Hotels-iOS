//
//  PriceRender.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/7/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class PriceRender {
    var currencyCode: String {
        didSet {
            self.formatter.currencyCode = currencyCode
        }
    }
    var formatter : NSNumberFormatter
    
    init(currencyCode: String, short: Bool) {
        self.formatter = NSNumberFormatter()
        self.formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        if short {
            self.formatter.maximumFractionDigits=0
        }
        self.currencyCode = currencyCode
        self.formatter.currencyCode = currencyCode
    }
    
    func render(rate: Rate) -> String {
        let prepaidPrice = NSString(string: rate.payment.prepaid[currencyCode]!).doubleValue
        if  prepaidPrice > 0 {
            return self.formatter.stringFromNumber(prepaidPrice)!
        }
        
        let postpaidPrice = NSString(string: rate.payment.postpaid[currencyCode]!).doubleValue
        return self.formatter.stringFromNumber(postpaidPrice)!
        
    }
    
    
}