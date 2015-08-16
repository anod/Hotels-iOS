//
//  BookingScreenController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/8/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import CoreData

class BookingScreenController: UIViewController, EtbApiDelegate, ExpirationPickerControllerDelegate {
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var summary: SummaryView!
    @IBOutlet weak var form: FormView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var bookButton: UIButton!

    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext

    
    var accomodation: Accommodation!
    var rateId : String!
    var availabilityRequest: AvailabilityRequest!
    var api: EtbApi!
    var rate: Rate!
    var expMonth = 0
    var expYear = 0
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ExperationPickerController" {
            let vc = segue.destinationViewController as! ExpirationPickerController
            vc.delegate = self
            vc.selectedMonth = expMonth
            vc.selectedYear = expYear
        }
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
    
    func expirationDidSelectMonth(month: Int, year: Int) {
        expMonth = month
        expYear = year
        form.setExpirationMonth(month, year: year)
    }
    
    func orderSuccessResult(result:OrderResult) {
        loadingView.hidden = true
        bookButton.enabled = true
        
        saveOrder(result.order!)
        
        let vc : ConfirmationController = ControllerUtils.instantiate("ConfirmationController")
        vc.result = result
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func saveOrder(order: Order) {
        
        let orderSummary = NSEntityDescription.insertNewObjectForEntityForName("OrderSummary", inManagedObjectContext: managedObjectContext)
        
        orderSummary.setValue(order.orderId, forKey: "orderId")
        orderSummary.setValue(availabilityRequest.checkInDate, forKey: "checkIn")
        orderSummary.setValue(availabilityRequest.checkOutDate, forKey: "checkOut")
        orderSummary.setValue(availabilityRequest.persons(), forKey: "persons")
        orderSummary.setValue(accomodation.name, forKey: "hotelName")
        orderSummary.setValue(AccommodationRender.address(accomodation), forKey: "hotelAddress")
        
        
        // save it
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Failure to save context: \(error)")
        }
        
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
    

}
