//
//  HodelDetailsHeader.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/12/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import HCSStarRatingView

protocol HotelDetailsHeaderDelegate {
    func pinAction()
}

class HotelDetailsHeader: UIView, HotelDetailsViewProtocol {
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelStars: HCSStarRatingView!
    @IBOutlet weak var pinButton: UIButton!

    var delegate: HotelDetailsHeaderDelegate!

    static func loadFromNib() -> HotelDetailsHeader {
        return UIView.loadViewFromNib("HotelDetailsHeader", theClass: self) as! HotelDetailsHeader
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.userInteractionEnabled = true
        pinButton.addTarget(self, action: Selector("pinAction:"), forControlEvents: UIControlEvents.TouchUpInside)

    }
    
    func pinAction(button: UIButton) {
        delegate.pinAction()
    }
    
    func attach(accomodation: Accommodation) {
        
        hotelName.text = accomodation.name
        hotelStars.value = CGFloat(accomodation.starRating)
        
    }
    

    
    
}
