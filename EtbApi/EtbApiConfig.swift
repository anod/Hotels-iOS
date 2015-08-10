//
// Created by Alex Gavrishev on 6/27/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

struct EtbApiConfig {
    private let defaultApiServerBase = "http://api.easytobook.com/v1"
    private let defaultApiServerBaseSecure = "https://api.easytobook.com/v1"

    var apiKey = ""
    var serverBase = ""
    var serverBaseSecure = ""

    init(apiKey: String) {
        self.apiKey = apiKey
        self.serverBase = defaultApiServerBase
        self.serverBaseSecure = defaultApiServerBaseSecure
    }

    init(apiKey: String, serverBase: String, serverBaseSecure: String) {
        self.apiKey = apiKey
        self.serverBase = serverBase
        self.serverBaseSecure = serverBaseSecure
    }

}
