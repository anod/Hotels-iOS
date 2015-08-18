//
//  CreditCardUtils.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/18/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class CreditCardUtils {
    
    let validator = CreditCardValidator()
    
    func onlyNumbersFromString(number: String) -> String! {
        return validator.onlyNumbersFromString(number)
    }
    
    func detectCreditCard(number: String) -> CreditCard? {
        if number.isEmpty {
            return nil
        }
        
        if let type = validator.typeFromString(number) {
            if type.name == "Visa" {
                return CreditCard.Visa
            }
            if type.name == "Amex" {
                return CreditCard.Amex
            }
            if type.name == "MasterCard" {
                return CreditCard.MasterCard
            }
            if type.name == "Discover" {
                return CreditCard.Discover
            }
            if type.name == "JCB" {
                return CreditCard.JCB
            }
            if type.name == "Diners Club" {
                return CreditCard.DinersClub
            }
            
            //            "name": "Maestro",
            //            "name": "UnionPay",
            
            return nil
        }
        return nil
    }
}