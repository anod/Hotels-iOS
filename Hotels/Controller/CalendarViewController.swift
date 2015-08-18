//
//  CalendarViewController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/10/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation


protocol CalendarViewControllerDelegate : NSObjectProtocol {
    func didDateUpdateWithCheckIn(checkIn: NSDate, checkOut: NSDate)
}

class CalendarViewController: UIViewController {
    @IBOutlet weak var typeControl: UISegmentedControl!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var currentNights: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let oneDaySeconds: Double = 86400
    let oneYearSeconds: Double = 365*86400
    
    var selectedSegmentIndex = 0
    var checkInDate: NSDate!
    var checkOutDate: NSDate!
    
    weak var delegate: CalendarViewControllerDelegate? // default is nil. weak reference

    let formatter = NSDateIntervalFormatter()
    let cal = NSCalendar.currentCalendar()

    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = NSDateIntervalFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateIntervalFormatterStyle.NoStyle
        
        checkInDate = onlyDate(checkInDate)
        checkOutDate = onlyDate(checkOutDate)
        
        datePicker.minimumDate = NSDate()
        datePicker.maximumDate = NSDate(timeIntervalSinceNow: oneYearSeconds)
        datePicker.setDate(checkInDate, animated: false)
        
        selectedSegmentIndex = typeControl.selectedSegmentIndex
        
        renderText()
    }
    
    // MARK: Actions
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        if sender.selectedSegmentIndex == 0 {
            datePicker.minimumDate = NSDate()
            datePicker.setDate(checkInDate, animated: true)
        } else {
            datePicker.minimumDate = NSDate(timeInterval: oneDaySeconds, sinceDate: checkInDate)
            datePicker.setDate(checkOutDate, animated: true)
        }
    }
    
    @IBAction func dateDidChange(sender: UIDatePicker) {
        if selectedSegmentIndex == 0 {
            checkInDate = onlyDate(sender.date)

            let cmp = checkOutDate.compare(checkInDate)
            if  cmp == NSComparisonResult.OrderedAscending || cmp == NSComparisonResult.OrderedSame {
                checkOutDate = onlyDate(NSDate(timeInterval: oneDaySeconds, sinceDate: checkInDate))
            }
        } else {
            checkOutDate = onlyDate(sender.date)
        }

        let cmp = checkOutDate.compare(checkInDate)
        if  cmp == NSComparisonResult.OrderedDescending {
            renderText()
            self.delegate?.didDateUpdateWithCheckIn(checkInDate, checkOut: checkOutDate)
        }

    }
    
    // MARK: Methods
    
    func onlyDate(date: NSDate) -> NSDate{
        let components = cal.components([.Year , .Month , .Day], fromDate: date)
        return cal.dateFromComponents(components)!
    }
    
    func renderText() {

        currentDate.text = formatter.stringFromDate(checkInDate, toDate: checkOutDate)
        
        let flags = NSCalendarUnit.Day
        let components = cal.components(flags, fromDate: checkInDate, toDate: checkOutDate, options: [])
        
        currentNights.text = components.day == 1 ? "\(components.day) Night" : "\(components.day) Nights"
    }

}