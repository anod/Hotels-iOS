//
// Created by Alex Gavrishev on 6/26/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

enum Sort : String {
    case Popularity = "Popularity",
    Price = "Price - Low to high",
    Reviews = "Guest Reviews - Best to worst",
    Distance = "Distance"

    var printableDescription : String {
        get {
            return self.rawValue
        }
    }

    var orderBy: String{
        get {
            switch(self) {
            case Popularity:
                return "stars"
            case Price:
                return "price"
            case Reviews:
                return "rating"
            case Distance:
                return "distance"
            }
        }
    }
}
