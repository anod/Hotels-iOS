//
//  FormView.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/8/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class FormView: UIView, CardIOPaymentViewControllerDelegate {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var emailAddress: UITextField!

    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var postcode: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var state: UITextField!

    @IBOutlet weak var ccFirstName: UITextField!
    @IBOutlet weak var ccLastName: UITextField!
    @IBOutlet weak var ccNumber: UITextField!
    @IBOutlet weak var ccExpiration: UIButton!
    @IBOutlet weak var ccCVV: UITextField!
    
    @IBOutlet weak var specialRequest: UITextField!

    var ccType = ""

    var parentController : UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ccExpiration.backgroundColor = UIColor.clearColor()
        ccExpiration.layer.cornerRadius = 5
        ccExpiration.layer.borderWidth = 1
        ccExpiration.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        // Do any additional setup after loading the view, typically from a nib.
        CardIOUtilities.preload()
    }
    
    @IBAction func ccNumberChange(sender: AnyObject) {
        if let number = ccNumber.text {
            print(number)
            let type = EtbApiUtils.detectCreditCard(number)
            print(type)
        }
    }
    
    @IBAction func scanCard(sender: AnyObject) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC.modalPresentationStyle = .FormSheet
        parentController.presentViewController(cardIOVC, animated: true, completion: nil)
    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            print(str)
        }
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }  
    
    func getPersonal() -> Personal {
        
        let personal = Personal()
        
        personal.firstName = firstName.text
        personal.lastName = lastName.text
        personal.phone = phoneNumber.text
        personal.email = emailAddress.text
        
        personal.country = country.text
        
        return personal
    }
    
    func getPayment() -> Payment {
        let payment = Payment()
        
        payment.type = ccType
        payment.data.ccFirstName = ccFirstName.text
        payment.data.ccLastName = ccLastName.text
        payment.data.ccNr = ccNumber.text
        payment.data.ccExpiryMonth = 0 // TODO
        payment.data.ccExpiryYear = 0 // TODO
        payment.data.ccCvc = ccCVV.text
        
        payment.billingAddress.country = country.text
        payment.billingAddress.postalCode = postcode.text
        payment.billingAddress.city = city.text
        payment.billingAddress.address = address.text
        payment.billingAddress.state = state.text
        
        return payment
    }
    
    func getSpecialRequest() -> String {
        return specialRequest.text!
    }
    
}