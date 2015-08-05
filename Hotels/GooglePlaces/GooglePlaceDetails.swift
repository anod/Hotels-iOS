//
//  GooglePlaceDetails.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/5/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class GooglePlaceDetails: CustomStringConvertible {
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(json: [String: AnyObject]) {
        let result = json["result"] as! [String: AnyObject]
        let geometry = result["geometry"] as! [String: AnyObject]
        let location = geometry["location"] as! [String: AnyObject]
        
        self.name = result["formatted_address"] as! String
        self.latitude = location["lat"] as! Double
        self.longitude = location["lng"] as! Double
    }
    
    init(lat: Double , lon: Double){
        self.latitude = lat
        self.longitude = lon
        self.name = ""
    }
    
    var description: String {
        return "GooglePlaceDetails: \(name) (\(latitude), \(longitude))"
    }
}