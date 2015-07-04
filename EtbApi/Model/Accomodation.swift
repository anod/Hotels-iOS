//
// Created by Alex Gavrishev on 6/11/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

class Accommodation :NSObject {

    var id: NSString?
    var name: NSString?
    var starRating: CGFloat = 0
    var images = [String]()
    var postpaidCurrency: NSString?
    var mainFacilities = [AnyObject]?()
    var rates = [Rate]()
    var location: Location?
    var summary = Summary()
    var fromPrice = [NSString: NSString]?()
    var details: Details?
    var extraInformation :ExtraInformation?
    var facilities = [Facilities]()


    class Facilities :NSObject{
        var id:NSString?
        var name:NSString?
        var category:NSString?
    }


    class Location :NSObject{
        var lat: NSString?
        var lon: NSString?
    }

    class Summary :NSObject{
        var address: NSString?
        var zipcode: NSString?
        var reviewScore: CGFloat = 0
        var reviewCount: NSString?
        var accType: NSString?
        var erank: NSString?
        var city: NSString?
        var country: NSString?
    }

    class Details :NSObject{
        var generalDescription: NSString?
        var importantInfo:NSString?
        var checkInFrom:NSString?
        var checkInUntil:NSString?
        var checkOutFrom:NSString?
        var checkOutUntil:NSString?
        var location:NSString?
        var nrOfRooms:NSString?
        var petsPolic = [NSString:Bool]?()
        var postpaidCreditCards = [NSString:NSString]?()
    }

    class ExtraInformation :NSObject{
        var extraField1: NSString?
        var extraField2: NSString?
    }

    class Rate :NSObject{
        var rateId: NSString?
        var name: NSString?
        var taxesAndFees = [TaxesAndFees]()
        var payment: Payment?
        var capacity: NSString?
        //        var description: NSString?
        var rateKey: NSString?
        var tags: Tags?
        var baseRate = [String:String]?()
        var totalNetRate = [String:String]?()
        var specialOffers = [SpecialOffers]()


        class TaxesAndFees :NSObject {
            var name: NSString?
            var type: NSString?
            var totalValue: TotalValue?

            class TotalValue: NSObject {
                var EUR : NSString?
            }
        }

        class SpecialOffers:NSObject {
            var type: NSString?
            var percentage: NSString?
            var nights: NSString?
        }

        class Payment :NSObject {
            var prepaid = [String:String]?()
            var postpaid = [String:String]?()

        }

        class Tags :NSObject {
            var breakfastIncluded:Bool = false
            var earlyBird :Bool = false
            var freeCancellation :Bool = false
            var lastMinute :Bool = false
            var nonRefundable :Bool = false
        }
    }
}