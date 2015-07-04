//
// Created by Alex Gavrishev on 6/11/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

class Meta: NSObject {

    var statusCode:NSString?
    var clientCurrency:NSString?
    var totalNrOverall:Int = 0
    var totalNr:Int = 0
    var limit:Int = 0
    var offset:Int = 0
    var overall:NSString?
    var filterNrs:FilterNrs?



    class FilterNrs:NSObject {
        var rating:AnyObject?//[NSString:NSString]()
        var accType:AnyObject?//NSDictionary = [NSString:NSString]()
        var facilities:AnyObject?//NSDictionary = [NSString:NSString]()
        var stars:AnyObject?//NSDictionary = [NSString:NSString]()
    }

}