//
// Created by Alex Gavrishev on 7/11/15.
// Copyright (c) 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

extension UIView {

    class func loadViewFromNib(nibName:String,theClass:AnyObject) -> UIView {
        let bundle = NSBundle(forClass: theClass.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)

        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(theClass, options: nil)[0] as! UIView
        return view
    }
}