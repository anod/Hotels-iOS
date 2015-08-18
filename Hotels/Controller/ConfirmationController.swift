//
//  ConfirmationController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/10/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class ConfirmationController: UIViewController, EtbApiDelegate {
    @IBOutlet weak var summary: SummaryView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    var isBookingConfirmation = false
    var accommodation: Accommodation!
    var result: OrderResult?
    var api: EtbApi!
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api = ApiUtils.create()
        api.delegate = self
        
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
            } else if orderRate.statusCode != "Confirmed" {
                cancelButton.hidden = true
            }
        }
        
        
    }
    
    // MARK: Actions
    
    @IBAction func closeButtonAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelReservationActions(sender: AnyObject) {
        let orderId = result?.order!.orderId
        if let orderRate = result?.order!.rates[0] {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let rateId: String = orderRate.rate.rateId
            api.cancel(orderId!, rateId: rateId, confirmationId: orderRate.confirmationId)
        }
    }
    
    // MARK: EtbApiDelegate
    
    func cancelSuccessResult() {
        statusLabel.text = "Cancelled"
        cancelButton.userInteractionEnabled = false
    }
    
    func cancelErrorResult(error:NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        ErrorAlertView.show("Search failed. Please try again", controller: self)
        print(error)
    }
    
}