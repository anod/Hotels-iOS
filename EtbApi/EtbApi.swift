//
// Created by Alex Gavrishev on 6/11/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation
import Alamofire

class EtbApi {

    var delegate: EtbApiDelegate! = nil
    var config: EtbApiConfig

    var alamofire: Alamofire.Manager
    
    init(config: EtbApiConfig) {
        self.config = config
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "api.easytobook.com": .PinCertificates(
                certificates: ServerTrustPolicy.certificatesInBundle(),
                validateCertificateChain: true,
                validateHost: true
            ),
            "trunk.api.easytobook.us": .DisableEvaluation
        ]
        
        self.alamofire = Manager(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
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
                "rating": request.prepareRating(),
                "stars": request.prepareStars(),
                "minRate": request.minRate,
                "maxRate": request.maxRate,
                "accTypes": request.prepareAccTypes(),
                "mainFacilities": request.prepareMainFacilities(),
                "currency": request.currency,
                "language" : request.language
        ]


        self.alamofire.request(.GET, self.config.serverBase + "/accommodations/results", parameters: query)
            .responseObject { (request, response, results: Result<AccommodationsResults>) in
                    if let delegate = self.delegate {
                        if results.isFailure {
                            delegate.searchErrorResult!(results.error!)
                            return;
                        }
                        
                        if (results.value?.meta!.statusCode == 200) {
                            delegate.searchSuccessResult!(results.value!)
                        } else {
                            let msg = NSString(string: (results.value?.meta!.errorMessage)!)
                            let error = NSError(domain: "EtbApi", code: (results.value?.meta!.errorCode)!, userInfo: [NSLocalizedDescriptionKey : msg])
                            delegate.searchErrorResult!(error)
                        }
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

        self.alamofire.request(.GET, self.config.serverBase + "/accommodations/\(accomodationId)", parameters: query)
            .responseObject { (request, response, results: Result<AccommodationDetails>) in
                if let delegate = self.delegate {
                    if results.isFailure {
                        delegate.detailsErrorResult!(results.error!)
                        return;
                    }
                    
                    if (results.value?.meta.statusCode == 200) {
                        delegate.detailsSuccessResult!(results.value!)
                    } else {
                        let msg = NSString(string: (results.value?.meta.errorMessage)!)
                        let error = NSError(domain: "EtbApi", code: (results.value?.meta.errorCode)!, userInfo: [NSLocalizedDescriptionKey : msg])
                        delegate.detailsErrorResult!(error)
                    }
                }
        }

    }
    
    func order(request: AvailabilityRequest, personal: Personal, payment: Payment, rateKey: String, rateCount: Int, remarks: String) {
        let apiKey = self.config.apiKey
        
        let ips = getIFAddresses()
        let query : [String : AnyObject] = [
            "currency": request.currency,
            "lang" : request.language,
            "customerIP" : ips[0],
            "personal" : [
                "firstName": personal.firstName,
                "lastName": personal.lastName,
                "phone": personal.phone,
                "country": personal.country,
                "email": personal.email
            ],
            "payment" : [
                "type" : payment.type,
                "data" : [
                    "ccNr" : payment.data.ccNr,
                    "ccCvc" : payment.data.ccCvc,
                    "ccFirstName" : payment.data.ccFirstName,
                    "ccLastName" : payment.data.ccLastName,
                    "ccExpiryMonth" : payment.data.ccExpiryMonth,
                    "ccExpiryYear" : payment.data.ccExpiryYear
                ],
                "billingAddress" : [
                    "country" : payment.billingAddress.country,
                    "state" : payment.billingAddress.state,
                    "city"  : payment.billingAddress.city,
                    "address": payment.billingAddress.address,
                    "postalCode": payment.billingAddress.postalCode
                ]
            ],
            "rates" : [
                [
                    "rateKey" : rateKey,
                    "rateCount": rateCount,
                    "beds" : [],
                    "remarks" : remarks
                ]
            ]
        ]
        
        self.alamofire.request(.POST, self.config.serverBaseSecure + "/orders/?apiKey=\(apiKey)", parameters: query, encoding: .JSON)
            .responseObject { (request, response, results: Result<OrderResult>) in
                if let delegate = self.delegate {
                    if results.isFailure {
                        delegate.orderErrorResult!(results.error!)
                        return;
                    }
                    if (results.value?.meta.statusCode == 200) {
                        delegate.orderSuccessResult!(results.value!)
                    } else {
                        let msg = NSString(string: (results.value?.meta.errorMessage)!)
                        let error = NSError(domain: "EtbApi", code: (results.value?.meta.errorCode)!, userInfo: [NSLocalizedDescriptionKey : msg])
                        delegate.orderErrorResult!(error)
                    }
                }
        }
    }
    
    func retrieve(orderId: Int) {
        let apiKey = self.config.apiKey
        
        self.alamofire.request(.GET, self.config.serverBaseSecure + "/orders/\(orderId)?apiKey=\(apiKey)", parameters: nil, encoding: .JSON)
            .responseObject { (request, response, results: Result<OrderResult>) in
                if let delegate = self.delegate {
                    if results.isFailure {
                        delegate.retrieveErrorResult!(results.error!)
                        return;
                    }
                    if (results.value?.meta.statusCode == 200) {
                        delegate.retrieveSuccessResult!(results.value!)
                    } else {
                        let msg = NSString(string: (results.value?.meta.errorMessage)!)
                        let error = NSError(domain: "EtbApi", code: (results.value?.meta.errorCode)!, userInfo: [NSLocalizedDescriptionKey : msg])
                        delegate.retrieveErrorResult!(error)
                    }
                }
        }
    }
    
    func cancel(orderId: Int, rateId: String, confirmationId: String) {
        let apiKey = self.config.apiKey
        
        let query : [String : AnyObject] = [
            "confirmationId": confirmationId,
            "reason" : 11, // Other
            "explanation" : "No explanation"
        ]
        
        self.alamofire.request(.POST, self.config.serverBaseSecure + "/orders/\(orderId)/rates/\(rateId)/cancel?apiKey=\(apiKey)", parameters: query, encoding: .JSON)
            .responseObject { (request, response, results: Result<CancelResult>) in
                if let delegate = self.delegate {
                    if results.isFailure {
                        delegate.cancelErrorResult!(results.error!)
                        return;
                    }
                    if (results.value?.meta.statusCode == 200) {
                        delegate.cancelSuccessResult!()
                    } else {
                        let msg = NSString(string: (results.value?.meta.errorMessage)!)
                        let error = NSError(domain: "EtbApi", code: (results.value?.meta.errorCode)!, userInfo: [NSLocalizedDescriptionKey : msg])
                        delegate.cancelErrorResult!(error)
                    }
                }
        }
    }
    
    private func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) /*|| addr.sa_family == UInt8(AF_INET6)*/ {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String.fromCString(hostname) {
                                    addresses.append(address)
                                }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses
    }
}
