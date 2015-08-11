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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form.parentController = self
        summary.attach(accomodation, rateId: rateId, availabilityRequest: availabilityRequest)

        backButton.target = self
        backButton.action = Selector("backButtonAction")

        //let rate = AccommodationUtils.findRate(rateId, accommodation: accomodation)
        

        
    }
    
    @IBAction func bookAction(sender: UIButton) {
        loadingView.hidden = false
        bookButton.enabled = false

        let api = ApiUtils.create()
        api.delegate = self
    }
    
    func orderSuccessResult(result:OrderResult) {
        loadingView.hidden = true
        bookButton.enabled = true
        
        
    }
    
    func orderErrorResult(error:NSError) {
        loadingView.hidden = true
        bookButton.enabled = true
    }
    
    func backButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
