//
// Created by Alex Gavrishev on 6/26/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

class SearchRequest {

    static let sharedInstance = SearchRequest()

    struct SortBy {
        var printableDescription = ""
        var orderByForRequest = ""
        var orderForRequest = ""
    }

    var lat: String = "0"
    var lot: String = "0"
    var checkInDate = ""
    var checkOutDate = ""
    var capacity = [String]()
    var searchingSort = SortBy()
    var minRate:String = "0" //min price
    var maxRate:String = "" //max price

    var stars = ""
    var rating = ""
    var accTypes = ""
    var mainFacilities = ""

    private var tempstars = Set<Int>()
    private var temprating = Set<Int>()
    private var tempaccTypes = Set<Int>()
    private var tempmainFacilities = Set<Int>()

    init(){
        self.searchingSort = SortBy(printableDescription:"", orderByForRequest:"", orderForRequest:"")

    }

    func prepareLocationForRequest() -> String{
        var locationStr = lat + "," + lot + ";" + "10"
        return locationStr;

    }

    func prepareCapacityForRequest() -> String{
        var newCapacity = ""

        if !capacity.isEmpty{
            for (var index = 0; index < capacity.count ; index++){
                newCapacity = index == 0 ? newCapacity + capacity[index] : newCapacity + "," + capacity[index]
            }
        }
        else{
            newCapacity = "2"
        }

        return newCapacity
    }


    func setStars(selectedNumber: Int){
        if tempstars.contains(selectedNumber){
            tempstars.remove(selectedNumber)
        }
        else{
            tempstars.insert(selectedNumber)
        }
        stars = EtbApiUtils.splitIntWithComma(tempstars)
    }

    func setRating(selectedNumber: Int){
        if temprating.contains(selectedNumber){
            temprating.remove(selectedNumber)
        }
        else{
            temprating.insert(selectedNumber)
        }
        rating = EtbApiUtils.splitIntWithComma(temprating)
    }


    func setAccTypes(selectedNumbers: Set<Int>){
        tempaccTypes = selectedNumbers
        accTypes = EtbApiUtils.splitIntWithComma(selectedNumbers)
    }

    func setFacilities(selectedNumbers: Set<Int>){
        tempmainFacilities = selectedNumbers
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