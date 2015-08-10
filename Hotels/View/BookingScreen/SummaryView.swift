//
//  SummaryView.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/8/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import HCSStarRatingView
import Haneke

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


    func attach(accommodation: Accommodation, rateId: String, availabilityRequest: AvailabilityRequest) {
        hotelName.text = accommodation.name
        hotelAddress.text = AccommodationRender.address(accommodation)
        hotelStars.value = CGFloat(accommodation.starRating)
        
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
        
        let rate = AccommodationUtils.findRate(rateId, accommodation: accommodation)
        roomName.text = rate!.name
        roomTags.text = AccommodationRender.rateTags(rate!)
        
        let priceRender = PriceRender(currencyCode: availabilityRequest.currency, short: false)
        
        roomPrice.text = priceRender.render(rate!)
        taxesAndFees.text = priceRender.taxes(rate!)
        
        totalPrice.text = priceRender.total(rate!)
        
        payToday.text=priceRender.prepaid(rate!)
        payAccomodation.text=priceRender.postpaid(rate!, postpaidCurrencyCode: accommodation.postpaidCurrency)

        let prepaidPrice = NSString(string: rate!.payment.prepaid[availabilityRequest.currency]!).doubleValue
        if prepaidPrice < 0.01 {
            localCurrencyText.text = "You will pay in local currency (\(accommodation.postpaidCurrency))"
        } else {
            localCurrencyText.hidden = true
        }

        
    }
    

}