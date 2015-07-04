//
// Created by Alex Gavrishev on 6/26/15.
// Copyright (c) 2015 Easytobook. All rights reserved.
//

import Foundation

enum Stars : Int {
    case Star1 = 1 ,Star2, Star3,Star4, Star5


    var detailsImageName: String{
        get {
            switch(self) {
            case Star1:
                return "stars-1.png"
            case Star2:
                return "stars-2.png"
            case Star3:
                return "stars-3.png"
            case Star4:
                return "stars-4.png"
            case Star5:
                return "stars-5.png"
            }

        }
    }

    var searchImageName: String{
        get {
            switch(self) {
            case Star1:
                return "search_stars-1.png"
            case Star2:
                return "search_stars-2.png"
            case Star3:
                return "search_stars-3.png"
            case Star4:
                return "search_stars-4.png"
            case Star5:
                return "search_stars-5.png"
            }

        }
    }


}