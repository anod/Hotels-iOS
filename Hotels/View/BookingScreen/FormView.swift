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
    @IBOutlet weak var ccTypeImage: UIImageView!
    @IBOutlet weak var ccTypeImageMask: UIView!
    
    
    @IBOutlet weak var specialRequest: UITextField!

    
    var ccType : CreditCard?
    var expMonth = 0
    var expYear = 0

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
            let type = EtbApiUtils.detectCreditCard(number)
            if type == nil {
                ccTypeImageMask.hidden = false
            } else if type == CreditCard.Visa {
                ccTypeImageMask.hidden = true
                ccTypeImage.image = UIImage(named: "credit_card_vise")
            } else if type == CreditCard.MasterCard {
                ccTypeImageMask.hidden = true
                ccTypeImage.image = UIImage(named: "credit_card_mastercard")
            } else if type == CreditCard.Amex {
                ccTypeImageMask.hidden = true
                ccTypeImage.image = UIImage(named: "credit_card_american_express")
            } else if type == CreditCard.DinersClub {
                ccTypeImageMask.hidden = true
                ccTypeImage.image = UIImage(named: "credit_card_diners_club")
            } else if type == CreditCard.Discover {
                ccTypeImageMask.hidden = true
                ccTypeImage.image = UIImage(named: "credit_card_discover")
            } else if type == CreditCard.JCB {
                ccTypeImageMask.hidden = true
                ccTypeImage.image = UIImage(named: "credit_card_jcb")
            }

            ccType = type
        } else {
            ccType = nil
            ccTypeImageMask.hidden = false
        }
    }
    
    @IBAction func scanCard(sender: AnyObject) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC.modalPresentationStyle = .FormSheet
        parentController.presentViewController(cardIOVC, animated: true, completion: nil)
    }
    
    func setExpirationMonth(month: Int, year: Int) {
        let title = month < 10 ? "0\(month)/\(year)" : "\(month)/\(year)"
        expMonth = month
        expYear = year
        ccExpiration.setTitle(title, forState: UIControlState.Normal)
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
        
        payment.type = ccType?.rawValue
        payment.data.ccFirstName = ccFirstName.text
        payment.data.ccLastName = ccLastName.text
        payment.data.ccNr = ccNumber.text
        payment.data.ccExpiryMonth = expMonth
        payment.data.ccExpiryYear = expYear
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