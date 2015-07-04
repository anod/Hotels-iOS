//
// Created by Alex Gavrishev on 6/26/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

enum AccType : Int {
    case Apartment = 1,
         BedAndBreafast = 2,
         Guesthouse = 3,
         Hostel = 4,
         Hotel = 5,
         Residence = 6,
         Resort = 7


    var AccTypeName: String{
        get {
            switch(self) {
            case Apartment:
                return "Apartment"
            case BedAndBreafast:
                return "BedAndBreafast"
            case Guesthouse:
                return "Guesthouse"
            case Hostel:
                return "Hostel"
            case Hotel:
                return "Hotel"
            case Residence:
                return "Residence"
            case Resort:
                return "Resort"

            }
        }
    }
}