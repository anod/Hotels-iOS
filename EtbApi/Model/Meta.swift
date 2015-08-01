//
// Created by Alex Gavrishev on 6/11/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

@objc
class Meta : NSObject, ResponseObjectSerializable {

    var statusCode:Int = 0
    var clientCurrency:String?

    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        self.statusCode = representation.valueForKeyPath("statusCode") as! Int
        self.clientCurrency = representation.valueForKeyPath("clientCurrency") as? String
    }

}