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
                "mainFacilities": request.mainFacilities
        ]

        Alamofire.request(.GET, URLString: self.config.serverBase + "/accommodations/results", parameters: query)
            .responseObject { (request, response, results: AccomodationsResults?, error) in
                    print(response)
                    if let delegate = self.delegate {
                        if let error = error {
                            delegate.searchErrorResult!(error)
                            return;
                        }
                        // TODO: handle errors in response
                        delegate.searchSuccessResult!(results!)
                    }
            }
    }


    func details(accomodationId: Int) {
//        let apiKey = self.config.apiKey
//
//        let responseDescriptor = RKResponseDescriptor(mapping: EtbApiRestKitMapping.prepareDetails(), method: RKRequestMethod.GET, pathPattern: nil, keyPath: nil, statusCodes: NSIndexSet(index: 200))
//        RKObjectManager.sharedManager().addResponseDescriptor(responseDescriptor)
//
//        let query = [
//                "apiKey": apiKey
//        ]
//        RKObjectManager.sharedManager().getObjectsAtPath("/accommodations/\(accomodationId)", parameters: query,
//
//                success: {
//                    operation, mappingResult in
//                    if let delegate = self.delegate {
//                        delegate.detailsSuccessResult!(EtbApiUtils.unwrapAccomodationDetailsObj(mappingResult))
//                    }
//                },
//
//                failure: {
//                    operation, error in
//                    if let delegate = self.delegate {
//                        delegate.detailsErrorResult!(error)
//                    }
//                    NSLog("\(error!.localizedDescription)")
//                }
//        )
    }
}
