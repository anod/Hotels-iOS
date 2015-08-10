//
//  FormView.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/8/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class FormView: UIView {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var emailAddress: UITextField!

    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var postcode: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var address: UITextField!

    @IBOutlet weak var ccFirstName: UITextField!
    @IBOutlet weak var ccLastName: UITextField!
    @IBOutlet weak var ccNumber: UITextField!
    @IBOutlet weak var ccExpiration: UITextField!
    @IBOutlet weak var ccCVV: UITextField!
    
}