//
// Created by Alex Gavrishev on 6/11/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

@objc
final class Accommodation: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {

    var id: Int!
    var name: String?
    var starRating: Float = 0
    var images = [String]()
    var postpaidCurrency: String!
    var mainFacilities : [Int]?
    var rates = [Rate]()
    var location = Location()
    var summary = Summary()
    var fromPrice = [String: String]()
    var details = Details()
    var extraInformation :ExtraInformation?
    var facilities = [Facilities]()


    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        self.id = representation.valueForKeyPath("id") as! Int
        self.name = representation.valueForKeyPath("name") as? String
        self.location.lat = representation.valueForKeyPath("location.lat") as! Double
        self.location.lon = representation.valueForKeyPath("location.lon") as! Double
        self.starRating = representation.valueForKey("starRating") as! Float
        self.images = representation.valueForKey("images") as! [String]
        self.fromPrice = representation.valueForKey("fromPrice") as! [String: String]
        self.mainFacilities = representation.valueForKey("mainFacilities") as? [Int]
        self.postpaidCurrency = representation.valueForKey("postpaidCurrency") as! String
        
        
        self.summary.address = representation.valueForKeyPath("summary.address") as? String
        self.summary.zipcode = representation.valueForKeyPath("summary.zipcode") as? String
        self.summary.reviewScore = representation.valueForKeyPath("summary.reviewScore") as! Float
        self.summary.reviewCount = representation.valueForKeyPath("summary.reviewCount") as! Int
        self.summary.city = representation.valueForKeyPath("summary.city") as? String
        self.summary.country = representation.valueForKeyPath("summary.country") as? String

        self.details.generalDescription = representation.valueForKeyPath("details.generalDescription") as? String
        self.details.importantInfo = representation.valueForKeyPath("details.importantInfo") as? String
        self.details.checkInFrom = representation.valueForKeyPath("details.checkInFrom") as? String
        self.details.checkInUntil = representation.valueForKeyPath("details.checkInUntil") as? String
        self.details.checkOutFrom = representation.valueForKeyPath("details.checkOutFrom") as? String
        self.details.checkOutUntil = representation.valueForKeyPath("details.checkOutUntil") as? String


        if let ratesJSON: AnyObject = representation.valueForKeyPath("rates") {
            self.rates = Rate.collection(response, representation: ratesJSON)
        }
        
    }

    static func collection(response: NSHTTPURLResponse, representation: AnyObject) -> [Accommodation] {
        var accomodations: [Accommodation] = []

        if let representation = representation as? [[String: AnyObject]] {
            for accRepresentation in representation {
                let accomodation = Accommodation(response: response, representation: accRepresentation)
                accomodations.append(accomodation)
            }
        }

        return accomodations
    }

    class Facilities {
        var id:String?
        var name:String?
        var category:String?
        var data:Data?
        
        class Data :NSObject {
            var free :Bool = false
            var location :String?
        }
    }
    
    
    class Location {
        var lat: Double = 0.0
        var lon: Double = 0.0
    }
    
    class Summary {
        var address: String!
        var zipcode: String!
        var reviewScore: Float = 0
        var reviewCount: Int = 0
        var accType = -1
        var erank: String?
        var city: String!
        var country: String!
    }
    
    class Details {
        var generalDescription: String?
        var importantInfo:String?
        var checkInFrom:String?
        var checkInUntil:String?
        var checkOutFrom:String?
        var checkOutUntil:String?
        var location:String?
        var nrOfRooms = 0
        var petsPolicy = PetsPolicy()
        var postpaidCreditCards = [PostpaidCreditCard]()
        
        
        class PostpaidCreditCard {
            var name: String?
            var code: String?
        }
        
        class PetsPolicy {
            var petsAllowed = 0
            var petsAllowedOnRequest = false
            var petsSurcharge = -1
        }
        
        func hasCheckInPolicy() -> Bool {
            if (checkInFrom != nil && checkInFrom!.isEmpty == false) {
                return true
            }
            if (checkInUntil != nil && checkInUntil!.isEmpty == false) {
                return true
            }
            if (checkOutFrom != nil && checkOutFrom!.isEmpty == false) {
                return true
            }
            if (checkOutUntil != nil && checkOutUntil!.isEmpty == false) {
                return true
            }
            return false
        }
    }
    
    class ExtraInformation {
        var extraField1: String?
        var extraField2: String?
    }
    

}