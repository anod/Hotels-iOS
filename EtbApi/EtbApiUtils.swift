//
// Created by Alex Gavrishev on 6/27/15.
// Copyright (c) 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class EtbApiUtils {

    class func splitIntWithComma(sets:Set<Int>)->String{
        var newString = ""
        var  index = 0
        if !sets.isEmpty{
            for set in enumerate(sets){
                newString = set.index == 0 ? newString + String(set.element) : newString + "," + String(set.element)

            }
        }
        return newString
    }

}
