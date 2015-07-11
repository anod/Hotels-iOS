//
// Created by Alex Gavrishev on 6/26/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

@objc
class AccomodationsResults : ResponseObjectSerializable {

    var meta:Meta?
    var accommodations = [Accommodation]()

    required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        if let metaJSON: AnyObject = representation.valueForKeyPath("meta") {
            self.meta = Meta(response: response, representation: metaJSON)
        }
        if let accommodationsJSON: AnyObject = representation.valueForKeyPath("accommodations") {
            self.accommodations = Accommodation.collection(response, representation: accommodationsJSON)
        }
    }
}