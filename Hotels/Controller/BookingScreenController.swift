//
//  BookingScreenController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/8/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class BookingScreenController: UIViewController {
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var summary: SummaryView!
    @IBOutlet weak var form: FormView!

    var accomodation: Accommodation!
    var rateId : String!
    var availabilityRequest: AvailabilityRequest!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        summary.attach(accomodation, rateId: rateId, availabilityRequest: availabilityRequest)
        
        backButton.target = self
        backButton.action = Selector("backButtonAction")
    }
    
    func backButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
