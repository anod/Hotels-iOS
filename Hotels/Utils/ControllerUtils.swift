//
//  ControllerUtils.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/16/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class ControllerUtils {
    
    static func mainStoryboard() -> UIStoryboard
    {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }
    
    static func instantiate<T : UIViewController>(identifier: String) -> T {
        return mainStoryboard().instantiateViewControllerWithIdentifier(identifier) as! T
    }
    
}