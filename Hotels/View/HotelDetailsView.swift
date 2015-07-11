//
//  HotelDetailsView.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/11/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class HotelDetailsView: UITableView {
    var accomodation: Accommodation!
    
    static func initWith(frame: CGRect, accomodation: Accommodation) -> HotelDetailsView {
        let view = UIView.loadViewFromNib("HotelDetailsView", theClass: HotelDetailsView.self) as! HotelDetailsView
        // use bounds not frame or it'll be offset
        view.frame = frame
        view.accomodation = accomodation
        
        return view;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
