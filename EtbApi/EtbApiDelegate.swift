//
// Created by Alex Gavrishev on 6/26/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

@objc
protocol EtbApiDelegate {

    optional func searchSuccessResult(result:AccommodationsResults)
    optional func searchErrorResult(error:NSError)

    optional func detailsSuccessResult(result:AccommodationDetails)
    optional func detailsErrorResult(error:NSError)

}