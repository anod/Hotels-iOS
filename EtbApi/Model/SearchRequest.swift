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
    
    var stars = ""
    var rating = ""
    var accTypes = ""
    var mainFacilities = ""
    
    private var tempstars = Set<Int>()
    private var temprating = Set<Int>()
    private var tempaccTypes = Set<Int>()
    private var tempmainFacilities = Set<Int>()
    
    override init(){
        self.searchingSort = SortBy(printableDescription:"", orderByForRequest:"", orderForRequest:"")
        
    }
    
    func prepareLocationForRequest() -> String{
        
        let latitude = String(format:"%f", lat)
        let longitude = String(format:"%f", lon)
        
        let locationStr =   latitude + "," + longitude + ";" + "10"
        return locationStr;
        
    }
    
    
    func setStars(selectedNumber: Int){
        if tempstars.contains(selectedNumber){
            tempstars.remove(selectedNumber)
        }
        else{
            tempstars.insert(selectedNumber)
        }
        stars = ""
        stars = EtbApiUtils.splitIntWithComma(tempstars)
        print("stars:\(stars)", appendNewline: false)
        
    }
    
    func setRating(selectedNumber: Int){
        if temprating.contains(selectedNumber){
            temprating.remove(selectedNumber)
        }
        else{
            temprating.insert(selectedNumber)
        }
        rating = ""
        rating = EtbApiUtils.splitIntWithComma(temprating)
    }
    
    
    func setAccTypes(selectedNumbers: Set<Int>){
        tempaccTypes = selectedNumbers
        accTypes = ""
        accTypes = EtbApiUtils.splitIntWithComma(selectedNumbers)
    }
    
    func setFacilities(selectedNumbers: Set<Int>){
        tempmainFacilities = selectedNumbers
        mainFacilities = ""
        mainFacilities = EtbApiUtils.splitIntWithComma(selectedNumbers)
    }
    
    func getStars() -> Set<Int>{
        return tempstars
    }
    
    func getRating() -> Set<Int>{
        return temprating
    }
    
    func getAccTypes() -> Set<Int>{
        return tempaccTypes
    }
    
    func getMainFacilities() -> Set<Int>{
        return tempmainFacilities
    }
    
    func destroy() {
        self.searchingSort = SortBy(printableDescription:"", orderByForRequest:"", orderForRequest:"")
        self.minRate = "0"
        self.maxRate = ""
        self.stars = ""
        self.rating = ""
        self.tempstars = []
        self.temprating = []
        self.accTypes = ""
        self.mainFacilities = ""
        self.tempaccTypes = []
        self.tempmainFacilities = []
    }

}