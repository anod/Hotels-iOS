//
// Created by Alex Gavrishev on 6/26/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

@objc
protocol EtbApiDelegate {

    optional func searchSuccessResult(result:AnyObject)
    optional func searchErrorResult(error:AnyObject)

    optional func detailsSuccessResult(result:AnyObject)
    optional func detailsErrorResult(error:AnyObject)

}