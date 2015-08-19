//
//  FormView.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/8/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class FormView: UIScrollView, CardIOPaymentViewControllerDelegate {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var emailAddress: UITextField!

    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var postcode: UITextField!
    @IBOutlet weak var country: UIButton!
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

    
    var ccType = CreditCard.Visa
    var expMonth = 0
    var expYear = 0
    var countryCode: String!
    
    var parentController : UIViewController!
    let ccTypeUtils = CreditCardUtils()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        ccExpiration.backgroundColor = UIColor.clearColor()
        ccExpiration.layer.cornerRadius = 5
        ccExpiration.layer.borderWidth = 1
        ccExpiration.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.6).CGColor
        
        country.backgroundColor = UIColor.clearColor()
        country.layer.cornerRadius = 5
        country.layer.borderWidth = 1
        country.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.6).CGColor
        
        // Do any additional setup after loading the view, typically from a nib.
        CardIOUtilities.preload()
    }
    
    @IBAction func ccNumberChange(sender: AnyObject) {
        if let number = ccNumber.text {
            let type = ccTypeUtils.detectCreditCard(number)
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

            if type != nil {
                ccType = type!
            }
        } else {
            ccTypeImageMask.hidden = false
        }
    }
    
    @IBAction func scanCard(sender: AnyObject) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC.modalPresentationStyle = .FormSheet
        parentController.presentViewController(cardIOVC, animated: true, completion: nil)
    }
    
    func setCountryName(name: String, code: String) {
        countryCode = code
        country.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        country.setTitle(name, forState: UIControlState.Normal)
    }
    
    func setExpirationMonth(month: Int, year: Int) {
        let title = month < 10 ? "0\(month)/\(year)" : "\(month)/\(year)"
        expMonth = month
        expYear = year
        ccExpiration.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        ccExpiration.setTitle(title, forState: UIControlState.Normal)
    }
    
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            ccNumber.text = info.cardNumber
            setExpirationMonth(Int(info.expiryMonth), year: Int(info.expiryYear))
            ccCVV.text = info.cvv
            ccNumberChange(ccNumber)
        }
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }  
    
    func getPersonal() -> Personal {
        
        let personal = Personal()
        
        personal.firstName = firstName.text
        personal.lastName = lastName.text
        personal.phone = phoneNumber.text
        personal.email = emailAddress.text
        
        personal.country = countryCode
        
        return personal
    }
    
    func getPayment() -> Payment {
        let payment = Payment()
        
        payment.type = ccType.rawValue
        payment.data.ccFirstName = ccFirstName.text
        payment.data.ccLastName = ccLastName.text
        payment.data.ccNr = ccTypeUtils.onlyNumbersFromString(ccNumber.text!)
        payment.data.ccExpiryMonth = expMonth
        payment.data.ccExpiryYear = expYear
        payment.data.ccCvc = ccCVV.text
        
        payment.billingAddress.country = countryCode
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