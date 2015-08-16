//
// Created by Alex Gavrishev on 6/26/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

class SearchRequest: AvailabilityRequest {

    static let sharedInstance = SearchRequest()
    struct SortBy {
        var printableDescription = ""
        var orderByForRequest = ""
        var orderForRequest = ""
    }
    
    var type: String = "spr"
    var lat: Double = 0
    var lon: Double = 0
    var searchingSort = SortBy()
    var minRate = "0" //min price
    var maxRate = "" //max price
    
    var stars = Set<Int>()
    var ratings = Set<Int>()
    var accTypes = Set<Int>()
    var mainFacilities = Set<Int>()
    
    override init(){
        self.searchingSort = SortBy(printableDescription:"", orderByForRequest:"", orderForRequest:"")
        
    }
    
    func prepareLocationForRequest() -> String{
        
        let latitude = String(format:"%f", lat)
        let longitude = String(format:"%f", lon)
        
        let locationStr =   latitude + "," + longitude + ";" + "10"
        return locationStr;
        
    }
    
    func prepareStars() -> String {
        return EtbApiUtils.splitIntWithComma(stars);
    }
    
    func prepareRating() -> String {
        return EtbApiUtils.splitIntWithComma(ratings)
    }
    
    func prepareAccTypes() -> String {
        return EtbApiUtils.splitIntWithComma(accTypes)
    }
    
    func prepareMainFacilities() -> String {
        return EtbApiUtils.splitIntWithComma(mainFacilities)
    }
    
    func setStars(stars: Set<Int>){
        self.stars = stars
    }
    
    func setRating(ratings: Set<Int>){
        self.ratings = ratings
    }
    
    func setAccTypes(accTypes: Set<Int>){
        self.accTypes = accTypes
    }
    
    func setMainFacilities(mainFacilities: Set<Int>){
        self.mainFacilities = mainFacilities
    }
    
    func destroy() {
        self.searchingSort = SortBy(printableDescription:"", orderByForRequest:"", orderForRequest:"")
        self.minRate = "0"
        self.maxRate = ""
        self.ratings = []
        self.stars = []
        self.accTypes = []
        self.mainFacilities = []
    }

}