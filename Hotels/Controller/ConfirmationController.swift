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
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    var isBookingConfirmation = false
    var accommodation: Accommodation!
    var result: OrderResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let orderRate = result?.order!.rates[0] {
            summary.attach(accommodation, rateId: orderRate.rate.rateId, availabilityRequest: orderRate.request)
            
            statusLabel.text = orderRate.statusCode
            let firstName = (result?.order!.personal.firstName)!
            let lastName  = (result?.order!.personal.lastName)!
            nameLabel.text = "\(firstName) \(lastName)"
            emailLabel.text = result?.order!.personal.email
            
            confirmationLabel.text = orderRate.confirmationId
            if isBookingConfirmation {
                cancelButton.hidden = true
            }
        }
        
        
        closeButton.target = self
        closeButton.action = Selector("backButtonAction")
    }
    
    func backButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}