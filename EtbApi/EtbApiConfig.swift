//
// Created by Alex Gavrishev on 6/27/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

struct EtbApiConfig {
    private let defaultApiServerBase = "http://api.easytobook.com/v1"
    var apiKey = "";
    var serverBase = "";

    init(apiKey: String) {
        self.apiKey = apiKey;
        self.serverBase = defaultApiServerBase;
    }

    init(apiKey: String, serverBase: String) {
        self.apiKey = apiKey;
        self.serverBase = serverBase;
    }

}
