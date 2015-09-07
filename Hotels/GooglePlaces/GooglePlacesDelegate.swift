//
//  GooglePlacesDelegate.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/5/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

protocol GooglePlacesDelegate {
    func googlePlacesErrorResult(searchText: String, error: ErrorType)
    func googlePlacesPredictions(results: [GoogleAutocompletePrediction])
    func googlePlacesDetailsResult(result: GooglePlaceDetails)
}