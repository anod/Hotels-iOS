//
// Created by Alex Gavrishev on 6/26/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation


@objc
class AccommodationDetails : NSObject, ResponseObjectSerializable {
    var meta:Meta?
    var accommodation:Accommodation?

    required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let JSON = representation.valueForKeyPath("meta");
        let stop = ""
        //self.meta = Meta(response: response, representation: (representation.valueForKeyPath("meta") as? [String: AnyObject])!)
        //       self.accommodations = Accommodation.collection(response: response, representation: representation.valueForKeyPath("accommodations") as? [String: AnyObject])
    }
}