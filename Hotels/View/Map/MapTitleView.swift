//
//  MapTitleView.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/10/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

protocol MapTitleViewDelegate {
    func showCalendar(source: UIButton)
}

class MapTitleView: UIView {
    @IBOutlet weak var calendarButton: UIButton!
    
    var request: AvailabilityRequest! {
        didSet {
            updateDates()
        }
    }
    var delegate: MapTitleViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        calendarButton.addTarget(self, action: Selector("buttonAction"), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func updateDates() {
        let formatter = NSDateIntervalFormatter()
        formatter.dateStyle = NSDateIntervalFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateIntervalFormatterStyle.NoStyle
        
        calendarButton.setTitle(formatter.stringFromDate(request.checkInDate, toDate: request.checkOutDate), forState: UIControlState.Normal)
    }
    
    func buttonAction() {
        self.delegate.showCalendar(calendarButton)
    }
    
}
