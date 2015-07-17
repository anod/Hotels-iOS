//
//  HotelDetailsCollectionView.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/17/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class HotelDetailsCollectionView: UICollectionView {
    var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
//        var view = super.hitTest(point, withEvent: event)
//        if (view == self) {
//            view = backView
//        }
//        return view
//    }

    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let index = self.indexPathForItemAtPoint(point)
        
        for view in self.subviews {
            if view.userInteractionEnabled && index != nil {
                return true
            }
        }
        return false
    }
    
}
