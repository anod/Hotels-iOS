//
//  SearchMeta.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/1/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

@objc
class SearchMeta : Meta {
    
    var totalNrOverall:Int = 0
    var totalNr:Int = 0
    var limit:Int = 0
    var offset:Int = 0
    var overall:String?
    var filterNrs:FilterNrs?
    
    required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        super.init(response: response, representation: representation)
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
