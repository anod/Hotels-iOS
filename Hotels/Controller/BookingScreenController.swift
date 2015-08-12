//
//  BookingScreenController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/8/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class BookingScreenController: UIViewController, EtbApiDelegate {
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var summary: SummaryView!
    @IBOutlet weak var form: FormView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var bookButton: UIButton!

    var accomodation: Accommodation!
    var rateId : String!
    var availabilityRequest: AvailabilityRequest!
    var api: EtbApi!
    var rate: Rate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form.parentController = self
        summary.attach(accomodation, rateId: rateId, availabilityRequest: availabilityRequest)

        backButton.target = self
        backButton.action = Selector("backButtonAction")

        rate = AccommodationUtils.findRate(rateId, accommodation: accomodation)
        
        api = ApiUtils.create()
        api.delegate = self

        
    }
    
    @IBAction func bookAction(sender: UIButton) {
        loadingView.hidden = false
        bookButton.enabled = false

        let personal = form.getPersonal()
        let payment = form.getPayment()
        let remarks = form.getSpecialRequest()
        let rateKey = rate.rateKey
        
        api.order(availabilityRequest, personal: personal, payment: payment, rateKey: rateKey!, rateCount: 1, remarks: remarks)
        
    }
    
    func orderSuccessResult(result:OrderResult) {
        loadingView.hidden = true
        bookButton.enabled = true
        
        let vc = mainStoryboard().instantiateViewControllerWithIdentifier("ConfirmationController") as! ConfirmationController
        vc.accomodation = accomodation
        vc.rateId = rateId
        vc.availabilityRequest = availabilityRequest
        vc.result = result
        vc.orderId = result.order?.orderId
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func orderErrorResult(error:NSError) {
        loadingView.hidden = true
        bookButton.enabled = true
        
        ErrorAlertView.show("\(error.localizedDescription)", controller: self)
        print(error)
    }
    
    func backButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mainStoryboard() -> UIStoryboard
    {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }
}
