//
//  GooglePlacesApi.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/5/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation
import Alamofire

class GooglePlacesApi {
    var delegate: GooglePlacesDelegate!
    
    let apiKey = "AIzaSyB6HwlFN0_ijbLjBMvf0N4Wo0E5_jnuXh8"
    let placesUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    let detailsUrl = "https://maps.googleapis.com/maps/api/place/details/json"
    
    func autocomplete(searchString:String){
        let query = [
            "input" : searchString,
            "key"   : apiKey,
            "types" : "geocode|establishment"
        ]
        
       Alamofire.request(.GET, self.placesUrl, parameters: query)
        .responseJSON(completionHandler: { (request, response, results: Result<AnyObject>) in
            if let delegate = self.delegate {
                if results.isFailure {
                    delegate.googlePlacesErrorResult(searchString, error: results.error!)
                    return;
                }
                
                let json = results.value as! [String: AnyObject]

                let status = json["status"] as! String
                if status == "OK" {
                    let predictionsJSON = json["predictions"] as! [[String: AnyObject]]
                    var predictions = [GoogleAutocompletePrediction]()
                    for predictionJson in predictionsJSON {
                        predictions.append(GoogleAutocompletePrediction(prediction: predictionJson))
                    }
                    delegate.googlePlacesPredictions(predictions)
                    
                } else {
                    let error = NSError(domain: "GooglePlacesApi", code: 400, userInfo: json)
                    
                    delegate.googlePlacesErrorResult(searchString, error: error)
                }
                
            }
        })
    }
    
    
    func details(place : GoogleAutocompletePrediction){
        let query = [
            "placeid" : place.id,
            "key"   : apiKey
        ]
        
        Alamofire.request(.GET, self.detailsUrl, parameters: query)
            .responseJSON(completionHandler: { (request, response, results: Result<AnyObject>) in
                if let delegate = self.delegate {
                    if results.isFailure {
                        delegate.googlePlacesErrorResult(place.desc, error: results.error!)
                        return;
                    }
                    
                    let json = results.value as! [String: AnyObject]
                    
                    let status = json["status"] as! String
                    if status == "OK" {
                        let details = GooglePlaceDetails(json: json)
                        delegate.googlePlacesDetailsResult(details)
                        
                    } else {
                        let error = NSError(domain: "GooglePlacesApi", code: 400, userInfo: json)
                        
                        delegate.googlePlacesErrorResult(place.desc, error: error)
                    }
                    
                }
            })
    }
    
    
}