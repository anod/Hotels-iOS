//
//  ApiUtils.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/11/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class ApiUtils {
    static func create() -> EtbApi {
        //let apiConfig = EtbApiConfig(apiKey: "SMXSJLLNOJida")
        //let apiConfig = EtbApiConfig(apiKey: "SMXSJLLNOJida", serverBase: "https://trunk.api.easytobook.us/v1", serverBaseSecure: "https://trunk.api.easytobook.us/v1")
        let apiConfig = EtbApiConfig(apiKey: "SMXSJLLNOJida", serverBase: "http://hotelswizard.azurewebsites.net/api", serverBaseSecure: "https://hotelswizard.azurewebsites.net/api")

        let api = EtbApi(config: apiConfig)
        
        return api
    }
}