//
//  ConfirmationController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/10/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class ConfirmationController: UIViewController {
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var summary: SummaryView!
    
    var accomodation: Accommodation!
    var rateId : String!
    var availabilityRequest: AvailabilityRequest!
    var orderId: Int!
    var result: OrderResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  summary.attach(accomodation, rateId: rateId, availabilityRequest: availabilityRequest)
        
        closeButton.target = self
        closeButton.action = Selector("backButtonAction")
    }
    
    func backButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}