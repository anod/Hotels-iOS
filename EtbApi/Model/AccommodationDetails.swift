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
        if let metaJSON: AnyObject = representation.valueForKeyPath("meta") {
            self.meta = Meta(response: response, representation: metaJSON)
        }
        if let accommodationJSON: AnyObject = representation.valueForKeyPath("accommodation") {
            self.accommodation = Accommodation(response: response, representation: accommodationJSON)
        }
    }
}