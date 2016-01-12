//
//  ErrorResult.swift
//  Hotels
//
//  Created by Alex Gavrishev on 1/12/16.
//  Copyright © 2016 Alex Gavrishev. All rights reserved.
//

import Foundation

class ErrorResult: ErrorType {
 
    var meta:Meta!
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        if let metaJSON: AnyObject = representation.valueForKeyPath("meta") {
            self.meta = Meta(response: response, representation: metaJSON)
        }
    }
}