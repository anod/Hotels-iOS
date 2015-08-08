//
//  BookingScreenController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/8/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class BookingScreenController: UIViewController {
    @IBOutlet weak var backButton: UIBarButtonItem!

    var accomodation: Accommodation!
    var rateId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.target = self
        backButton.action = Selector("backButtonAction")
    }
    
    func backButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
