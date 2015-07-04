//
// Created by Alex Gavrishev on 6/26/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

class EtbApiRestKitMapping {

    class func prepareAccommodations()-> RKObjectMapping{
        let resultsMapping = RKObjectMapping(forClass: AccomodationsResults.self)
        resultsMapping.addAttributeMappingsFromArray([])

        //metaMapping + searchingAccommodationsMapping
        let metaMapping = RKObjectMapping(forClass: Meta.self)
        metaMapping.addAttributeMappingsFromArray(["status","clientCurrency","totalNrOverall","totalNr","limit","offset","overall"])
        resultsMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "meta", toKeyPath: "meta", withMapping: metaMapping))

        //metaMapping + filterNrsMapping
        let filterNrsMapping = RKObjectMapping(forClass: Meta.FilterNrs.self)
        filterNrsMapping.addAttributeMappingsFromArray(["rating","accType","facilities","stars"])
        metaMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "filterNrs", toKeyPath: "filterNrs", withMapping: filterNrsMapping))


        //accommodationsMapping + searchingAccommodationsMapping
        let accommodationMapping = RKObjectMapping(forClass: Accommodation.self)
        accommodationMapping.addAttributeMappingsFromArray(["id","name","starRating","images","postpaidCurrency","mainFacilities","fromPrice"])
        resultsMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "accommodations", toKeyPath: "accommodations", withMapping: accommodationMapping))

        //accommodationsMapping + locationMapping
        let locationMapping = RKObjectMapping(forClass: Accommodation.Location.self)
        locationMapping.addAttributeMappingsFromArray(["lat","lon"])
        accommodationMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "location", toKeyPath: "location", withMapping: locationMapping))

        // accommodationsMapping + summaryMapping
        let summaryMapping = RKObjectMapping(forClass: Accommodation.Summary.self)
        summaryMapping.addAttributeMappingsFromArray(["address","zipcode","reviewScore","reviewCount","accType","erank","city","country"])
        accommodationMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "summary", toKeyPath: "summary", withMapping: summaryMapping))

        //accommodationsMapping + detailsMapping
        let detailsMapping = RKObjectMapping(forClass: Accommodation.Details.self)
        detailsMapping.addAttributeMappingsFromArray(["generalDescription"])
        accommodationMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "details", toKeyPath: "details", withMapping: detailsMapping))

        //accommodationsMapping + extraInformationMapping
        let extraInformationMapping = RKObjectMapping(forClass: Accommodation.ExtraInformation.self)
        extraInformationMapping.addAttributeMappingsFromArray(["extraField1","extraField2"])
        accommodationMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "extraInformation", toKeyPath: "extraInformation", withMapping: extraInformationMapping))

        //accommodationsMapping + ratesMapping
        let ratesMapping = RKObjectMapping(forClass: Accommodation.Rate.self)
        ratesMapping.addAttributeMappingsFromArray(["rateId","name","capacity","rateKey","baseRate","totalNetRate"])
        accommodationMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "rates", toKeyPath: "rates", withMapping: ratesMapping))


        //ratesMapping + taxesAndFeesMapping
        let taxesAndFeesMapping = RKObjectMapping(forClass: Accommodation.Rate.TaxesAndFees.self)
        taxesAndFeesMapping.addAttributeMappingsFromArray(["name","type"])
        ratesMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "taxesAndFees", toKeyPath: "taxesAndFees", withMapping: taxesAndFeesMapping))

        //ratesMapping + totalValueMapping
        let totalValueMapping = RKObjectMapping(forClass: Accommodation.Rate.TaxesAndFees.TotalValue.self)
        totalValueMapping.addAttributeMappingsFromArray(["EUR"])
        taxesAndFeesMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "totalValue", toKeyPath: "totalValue", withMapping: totalValueMapping))

        //ratesMapping + paymentMapping
        let paymentMapping = RKObjectMapping(forClass: Accommodation.Rate.Payment.self)
        paymentMapping.addAttributeMappingsFromArray(["prepaid","postpaid"])
        ratesMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "payment", toKeyPath: "payment", withMapping: paymentMapping))

        //ratesMapping + tagsMapping
        let tagsMapping = RKObjectMapping(forClass: Accommodation.Rate.Tags.self)
        tagsMapping.addAttributeMappingsFromArray(["breakfastIncluded","earlyBird","freeCancellation","lastMinute","nonRefundable"])
        ratesMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "tags", toKeyPath: "tags", withMapping: tagsMapping))

        //ratesMapping + specialOffersMapping
        let specialOffersMapping = RKObjectMapping(forClass: Accommodation.Rate.SpecialOffers.self)
        specialOffersMapping.addAttributeMappingsFromArray(["type","percentage","nights"])
        ratesMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "specialOffers", toKeyPath: "specialOffers", withMapping: specialOffersMapping))

        return resultsMapping
    }


    class func prepareDetails()-> RKObjectMapping{
        let detailsMapping = RKObjectMapping(forClass: AccommodationDetails.self)
        detailsMapping.addAttributeMappingsFromArray([])

        //metaMapping + searchingAccommodationsMapping
        let metaMapping = RKObjectMapping(forClass: Meta.self)
        metaMapping.addAttributeMappingsFromArray(["statusCode","clientCurrency"])
        detailsMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "meta", toKeyPath: "meta", withMapping: metaMapping))

        //accommodationsMapping + searchingAccommodationsMapping
        let accommodationMapping = RKObjectMapping(forClass: Accommodation.self)
        accommodationMapping.addAttributeMappingsFromArray(["id","name","starRating","images","postpaidCurrency","fromPrice"])
        detailsMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "accommodation", toKeyPath: "accommodation", withMapping: accommodationMapping))

        //accommodationsMapping + locationMapping
        let locationMapping = RKObjectMapping(forClass: Accommodation.Location.self)
        locationMapping.addAttributeMappingsFromArray(["lat","lon"])
        accommodationMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "location", toKeyPath: "location", withMapping: locationMapping))

        // accommodationsMapping + summaryMapping
        let summaryMapping = RKObjectMapping(forClass: Accommodation.Summary.self)
        summaryMapping.addAttributeMappingsFromArray(["address","zipcode","reviewScore","reviewCount","accType","erank","city","country"])
        accommodationMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "summary", toKeyPath: "summary", withMapping: summaryMapping))

        //accommodationsMapping + detailsMapping
        let accomodationDetailsMapping = RKObjectMapping(forClass: Accommodation.Details.self)
        accomodationDetailsMapping.addAttributeMappingsFromArray(["generalDescription","importantInfo"])
        accommodationMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "details", toKeyPath: "details", withMapping: detailsMapping))


        //accommodationsMapping + facilitiesMapping
        let facilitiesMapping = RKObjectMapping(forClass: Accommodation.Facilities.self)
        facilitiesMapping.addAttributeMappingsFromArray(["id","name","category"])
        accommodationMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "facilities", toKeyPath: "facilities", withMapping: facilitiesMapping))

        return detailsMapping
    }

}