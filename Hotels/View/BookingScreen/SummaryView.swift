//
//  SummaryView.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/8/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import HCSStarRatingView

class SummaryView: UIView, HotelDetailsViewProtocol{
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelAddress: UILabel!
    @IBOutlet weak var hotelStars: HCSStarRatingView!

    @IBOutlet weak var dates: UILabel!
    @IBOutlet weak var nights: UILabel!
    @IBOutlet weak var guests: UILabel!

    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomTags: UILabel!

    @IBOutlet weak var roomPrice: UILabel!
    @IBOutlet weak var taxesAndFees: UILabel!
    @IBOutlet weak var totalPrice: UILabel!

    @IBOutlet weak var payToday: UILabel!
    @IBOutlet weak var payAccomodation: UILabel!
    
    @IBOutlet weak var localCurrencyText: UILabel!
    

    func attach(accomodation: Accommodation, rateId: String, availabilityRequest: AvailabilityRequest) {
        hotelName.text = accomodation.name
        hotelAddress.text = AccommodationRender.address(accomodation)
        hotelStars.value = CGFloat(accomodation.starRating)
        
        let formatter = NSDateIntervalFormatter()
        formatter.dateStyle = NSDateIntervalFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateIntervalFormatterStyle.NoStyle
        
        dates.text = formatter.stringFromDate(availabilityRequest.checkInDate, toDate: availabilityRequest.checkOutDate)
        
        let cal = NSCalendar.currentCalendar()
        let flags = NSCalendarUnit.Day
        let components = cal.components(flags, fromDate: availabilityRequest.checkInDate, toDate: availabilityRequest.checkOutDate, options: [])
        
        nights.text = components.day == 1 ? "\(components.day) Night" : "\(components.day) Nights"
        let persons  = availabilityRequest.persons()
        guests.text = guests == 1 ? "\(persons) Guest" : "\(persons) Guests"
        
        let rate = AccommodationUtils.findRate(rateId, accommodation: accomodation)
        roomName.text = rate!.name
        roomTags.text = AccommodationRender.rateTags(rate!)
        
        
        
    }
}