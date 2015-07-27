//
//  HodelDetailsHeader.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/12/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import HCSStarRatingView
import Haneke

protocol HotelDetailsHeaderDelegate {
    func pinAction()
    func headerReady(image: UIImage)
}

class HotelDetailsHeader: UIView, HotelDetailsViewProtocol {
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelStars: HCSStarRatingView!
    @IBOutlet weak var pinButton: UIButton!

    var delegate: HotelDetailsHeaderDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.userInteractionEnabled = true
        pinButton.addTarget(self, action: Selector("pinAction:"), forControlEvents: UIControlEvents.TouchUpInside)

    }
    
    func pinAction(button: UIButton) {
        delegate.pinAction()
    }
    
    func attach(accomodation: Accommodation) {
        
        if (accomodation.images.count > 0) {
            let URL = NSURL(string: accomodation.images[0])!

            hotelImage.hnk_setImageFromURL(URL, placeholder: nil, format: nil, failure: nil, success: self.imageLoadSuccess)
        }
        hotelName.text = accomodation.name
        hotelStars.value = CGFloat(accomodation.starRating)
        
    }
    
    func imageLoadSuccess(image: UIImage) -> () {
        let animated = true
        let duration : NSTimeInterval = animated ? 0.1 : 0
        UIView.transitionWithView(self, duration: duration, options: .TransitionCrossDissolve, animations: {
            self.hotelImage.image = image
            }, completion: {
                success in
                
                self.delegate.headerReady(image)
        })
        
    }
    
    
}
