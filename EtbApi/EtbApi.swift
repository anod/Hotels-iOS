//
// Created by Alex Gavrishev on 6/11/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation
import Alamofire

class EtbApi {

    var delegate: EtbApiDelegate! = nil
    var config: EtbApiConfig

    init(config: EtbApiConfig) {
        self.config = config
    }

    func search(request: SearchRequest, offset: Int, limit: Int) {

        let apiKey = self.config.apiKey

        let query = [
                "apiKey": apiKey,
                "metaFields": "all",
                "showExtraInformation": "1",
                "type": request.type,
                "context": request.prepareLocationForRequest(),
                "offset": String(offset),
                "checkIn": EtbApiUtils.formatDate(request.checkInDate),
                "checkOut": EtbApiUtils.formatDate(request.checkOutDate),
                "limit": String(limit),
                "capacity": request.prepareCapacityForRequest(),
                "orderBy": request.searchingSort.orderByForRequest,
                "order": request.searchingSort.orderForRequest,
                "rating": request.rating,
                "stars": request.stars,
                "minRate": request.minRate,
                "maxRate": request.maxRate,
                "accTypes": request.accTypes,
                "mainFacilities": request.mainFacilities,
                "currency": request.currency,
                "language" : request.language
        ]

        Alamofire.request(.GET, self.config.serverBase + "/accommodations/results", parameters: query)
            .responseObject { (request, response, results: Result<AccommodationsResults>) in
                    if let delegate = self.delegate {
                        if results.isFailure {
                            delegate.searchErrorResult!(results.error!)
                            return;
                        }
                        // TODO: handle errors in response
                        delegate.searchSuccessResult!(results.value!)
                    }
            }
    }


    func details(accomodationId: Int, request: AvailabilityRequest) {
        let apiKey = self.config.apiKey

        let query = [
            "apiKey": apiKey,
            "checkIn": EtbApiUtils.formatDate(request.checkInDate),
            "checkOut": EtbApiUtils.formatDate(request.checkOutDate),
            "capacity": request.prepareCapacityForRequest(),
            "currency": request.currency,
            "language" : request.language
        ]

        Alamofire.request(.GET, self.config.serverBase + "/accommodations/\(accomodationId)", parameters: query)
            .responseObject { (request, response, results: Result<AccommodationDetails>) in
                if let delegate = self.delegate {
                    if results.isFailure {
                        delegate.detailsErrorResult!(results.error!)
                        return;
                    }
                    // TODO: handle errors in response
                    delegate.detailsSuccessResult!(results.value!)
                }
        }

    }
}
