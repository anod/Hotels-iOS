//
// Created by Alex Gavrishev on 6/11/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation


class EtbApi {

    var delegate: EtbApiDelegate? = nil
    var objectManager: RKObjectManager
    var config: EtbApiConfig

    init(config: EtbApiConfig) {
        self.config = config
        // initialize AFNetworking HTTPClient
        let baseURL = NSURL(string: config.serverBase)
        let client = AFHTTPClient(baseURL: baseURL)
        self.objectManager = RKObjectManager(HTTPClient: client)
        RKObjectManager.setSharedManager(objectManager)
    }

    func search(request: SearchRequest, offset: Int, limit: Int) {

        let apiKey = self.config.apiKey
        let responseDescriptor = RKResponseDescriptor(mapping: EtbApiRestKitMapping.prepareAccommodations(), method: RKRequestMethod.GET, pathPattern: nil, keyPath: nil, statusCodes: NSIndexSet(index: 200))
        RKObjectManager.sharedManager().addResponseDescriptor(responseDescriptor)

        let query = [
                "apiKey": apiKey,
                "metaFields": "all",
                "showExtraInformation": "1",
                "type": "spr",
                "context": request.prepareLocationForRequest(),
                "offset": String(offset),
                "checkIn": request.checkInDate,
                "checkOut": request.checkOutDate,
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

        RKObjectManager.sharedManager().getObjectsAtPath("/accommodations/results", parameters: query,

                success: {
                    operation, result in
                    if let delegate = self.delegate {
                        delegate.searchSuccessResult!(result)
                    }
                },

                failure: {
                    operation, error in
                    if let delegate = self.delegate {
                        delegate.searchErrorResult!(error)
                    }
                    NSLog("\(error!.localizedDescription)")
                }
        )
    }


    func details(accomodationId: Int) {
        let apiKey = self.config.apiKey

        let responseDescriptor = RKResponseDescriptor(mapping: EtbApiRestKitMapping.prepareDetails(), method: RKRequestMethod.GET, pathPattern: nil, keyPath: nil, statusCodes: NSIndexSet(index: 200))
        RKObjectManager.sharedManager().addResponseDescriptor(responseDescriptor)

        let query = [
                "apiKey": apiKey
        ]
        RKObjectManager.sharedManager().getObjectsAtPath("/accommodations/\(accomodationId)", parameters: query,

                success: {
                    operation, mappingResult in
                    if let delegate = self.delegate {
                        delegate.detailsSuccessResult!(mappingResult)
                    }
                },

                failure: {
                    operation, error in
                    if let delegate = self.delegate {
                        delegate.detailsErrorResult!(error)
                    }
                    NSLog("\(error!.localizedDescription)")
                }
        )
    }
}
