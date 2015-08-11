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
        let apiConfig = EtbApiConfig(apiKey: "SMXSJLLNOJida", serverBase: "http://trunk.api.easytobook.us/v1", serverBaseSecure: "https://trunk.api.easytobook.us/v1")
        return EtbApi(config: apiConfig)
    }
}