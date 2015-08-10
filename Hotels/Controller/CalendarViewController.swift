//
//  CalendarViewController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/10/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation
import GLCalendarView

class CalendarViewController: UIViewController {
    @IBOutlet weak var typeControl: UISegmentedControl!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var currentNights: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var applyButton: UIButton!
    
    var request: AvailabilityRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }

}