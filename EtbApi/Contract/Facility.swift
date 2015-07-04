//
// Created by Alex Gavrishev on 6/26/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

enum Facility : Int {
    case Disabled = 0,
         Internet = 1,
         Parking = 2,
         PetsAllowed = 3,
         ChildDiscount = 4,
         SwimmingPool = 5,
         AirConditioning = 6,
         FitnessCenter = 7,
         NonSmoking = 8



    var FacilityName: String{
        get {
            switch(self) {
            case Disabled:
                return "Disabled"
            case Internet:
                return "Internet"
            case Parking:
                return "Parking"
            case PetsAllowed:
                return "PetsAllowed"
            case ChildDiscount:
                return "ChildDiscount"
            case SwimmingPool:
                return "SwimmingPool"
            case AirConditioning:
                return "AirConditioning"
            case FitnessCenter:
                return "FitnessCenter"
            case NonSmoking:
                return "NonSmoking"

            }
        }
    }


    var detailsImageName: String{
        get {
            switch(self) {
            case Disabled:
                return ""
            case Internet:
                return "wifi.png"
            case Parking:
                return "parking.png"
            case PetsAllowed:
                return "pets.png"
            case ChildDiscount:
                return ""
            case SwimmingPool:
                return "pool.png"
            case AirConditioning:
                return ""
            case FitnessCenter:
                return ""
            case NonSmoking:
                return ""
            }
        }
    }
}