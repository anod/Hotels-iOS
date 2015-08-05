//
//  GooglePlace.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/5/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation


class GoogleAutocompletePrediction {
    let id: String
    let desc: String   
   
    init(id: String, description: String) {
        self.id = id
        self.desc = description
    }
    
//    {
//    "description" : "Paris, France",
//    "id" : "691b237b0322f28988f3ce03e321ff72a12167fd",
//    "matched_substrings" : [
//    {
//    "length" : 5,
//    "offset" : 0
//    }
//    ],
//    "place_id" : "ChIJD7fiBh9u5kcRYJSMaMOCCwQ",
//    "reference" : "CjQlAAAA_KB6EEceSTfkteSSF6U0pvumHCoLUboRcDlAH05N1pZJLmOQbYmboEi0SwXBSoI2EhAhj249tFDCVh4R-PXZkPK8GhTBmp_6_lWljaf1joVs1SH2ttB_tw",
//    "terms" : [
//    {
//    "offset" : 0,
//    "value" : "Paris"
//    },
//    {
//    "offset" : 7,
//    "value" : "France"
//    }
//    ],
//    "types" : [ "locality", "political", "geocode" ]
//    },
    convenience init(prediction: [String: AnyObject]) {
        self.init(
            id: prediction["place_id"] as! String,
            description: prediction["description"] as! String
        )
    }
}