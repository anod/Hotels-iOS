//
// Created by Alex Gavrishev on 6/27/15.
// Copyright (c) 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class EtbApiUtils {

    class func splitIntWithComma(sets:Set<Int>)->String{
        var newString = ""
        var  index = 0
        if !sets.isEmpty{
            for set in enumerate(sets){
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
    
    class func unwrapAccommodationResult(result:AnyObject) -> AccomodationsResults?{
        
        let results: NSArray = result.array
        
        if (results.count > 0){
            let searchingAccommodations = results[0] as! AccomodationsResults
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
}
