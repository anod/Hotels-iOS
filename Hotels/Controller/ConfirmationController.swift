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
    
    var result: OrderResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let orderRate = result?.order!.rates[0] {
            summary.attach(orderRate.accommodation, rateId: orderRate.rate.rateId, availabilityRequest: orderRate.request)
        }
        
        closeButton.target = self
        closeButton.action = Selector("backButtonAction")
    }
    
    func backButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}