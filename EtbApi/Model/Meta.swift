//
// Created by Alex Gavrishev on 6/11/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

@objc
class Meta : NSObject, ResponseObjectSerializable {

    var statusCode:Int = 0
    var clientCurrency:String?
    var totalNrOverall:Int = 0
    var totalNr:Int = 0
    var limit:Int = 0
    var offset:Int = 0
    var overall:String?
    var filterNrs:FilterNrs?

    required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.statusCode = representation.valueForKeyPath("statusCode") as! Int
        self.clientCurrency = representation.valueForKeyPath("clientCurrency") as? String
        self.totalNrOverall = representation.valueForKeyPath("totalNrOverall") as! Int
        self.totalNr = representation.valueForKeyPath("totalNr") as! Int
        self.limit = representation.valueForKeyPath("limit") as! Int
        self.offset = representation.valueForKeyPath("offset") as! Int
        //self.filterNrs = representation.valueForKeyPath("filterNrs") as! Int
    }


    class FilterNrs {
        var rating:AnyObject?//[NSString:NSString]()
        var accType:AnyObject?//NSDictionary = [NSString:NSString]()
        var facilities:AnyObject?//NSDictionary = [NSString:NSString]()
        var stars:AnyObject?//NSDictionary = [NSString:NSString]()

        required init?(response: NSHTTPURLResponse, representation: AnyObject) {
            // TODO:
        }
    }

}