//
// Created by Alex Gavrishev on 6/27/15.
// Copyright (c) 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class EtbApiUtils {

    class func splitIntWithComma(sets:Set<Int>)->String{
        var newString = ""
        if !sets.isEmpty{
            for set in sets.enumerate(){
                newString = set.index == 0 ? newString + String(set.element) : newString + "," + String(set.element)

            }
        }
        return newString
    }

    class func formatDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(date)
    }
    
    class func unwrapAccommodationResult(result:AnyObject) -> AccommodationsResults?{
        
        let results: NSArray = result.array
        
        if (results.count > 0){
            let searchingAccommodations = results[0] as! AccommodationsResults
            return searchingAccommodations
        }
        
        return nil
    }
    
    class func unwrapAccomodationDetailsObj(result:AnyObject) -> AccommodationDetails!{
        
        let results: NSArray = result.array
        
        if (results.count > 0){
            let accommodationDetails = results[0] as! AccommodationDetails
            return accommodationDetails
        }
        
        return nil
    }
    
    static func detectCreditCard(number: String) -> CreditCard? {
        if number.isEmpty {
            return nil
        }
        
        
        let v = CreditCardValidator()
        if let type = v.typeFromString(number) {
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
