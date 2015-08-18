//
//  CancelResult.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/18/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class CancelResult : NSObject, ResponseObjectSerializable {
    
    var meta:Meta!
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        if let metaJSON: AnyObject = representation.valueForKeyPath("meta") {
            self.meta = Meta(response: response, representation: metaJSON)
        }
    }
}