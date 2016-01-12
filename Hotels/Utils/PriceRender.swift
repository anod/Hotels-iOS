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
        let prepaidPrice = rate.payment.prepaid[currencyCode]!
        if  prepaidPrice > 0 {
            return self.formatter.stringFromNumber(prepaidPrice)!
        }
        
        let postpaidPrice = rate.payment.postpaid[currencyCode]!
        return self.formatter.stringFromNumber(postpaidPrice)!
        
    }
    
    func taxes(rate: Rate) -> String {
        let prepaidPrice = rate.payment.prepaid[currencyCode]!
        let postpaidPrice = rate.payment.postpaid[currencyCode]!
        
        let totalPrice = prepaidPrice + postpaidPrice;
        
        let totalNetPrice = rate.totalNetRate[currencyCode]!
        
        return self.formatter.stringFromNumber(totalPrice - totalNetPrice)!
    }
 
    func online(rate: Rate) -> String {
        let prepaidPrice = rate.totalNetRate[currencyCode]!
        return self.formatter.stringFromNumber(prepaidPrice)!
    }
 
    func total(rate: Rate) -> String {
        let prepaidPrice = rate.payment.prepaid[currencyCode]!
        let postpaidPrice = rate.payment.postpaid[currencyCode]!
        
        let totalPrice = prepaidPrice + postpaidPrice;
        
        return self.formatter.stringFromNumber(totalPrice)!
    }
    
    func prepaid(rate: Rate) -> String {
        let prepaidPrice = rate.payment.prepaid[currencyCode]!
        return self.formatter.stringFromNumber(prepaidPrice)!
    }
    
    func postpaid(rate: Rate, postpaidCurrencyCode: String) -> String {
        let postpaidPrice = rate.payment.postpaid[postpaidCurrencyCode]!
        
        let postpaidFormatter = NSNumberFormatter()
        postpaidFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        postpaidFormatter.currencyCode = postpaidCurrencyCode
        
        return postpaidFormatter.stringFromNumber(postpaidPrice)!
    }
}