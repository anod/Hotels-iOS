//
//  CountryPickerController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/18/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class CountryPickerController: UIViewController {
    @IBOutlet weak var pickerView: CountryPicker!
    
    var selectedCountryCode : String!
    
    weak var delegate: CountryPickerDelegate? // default is nil. weak reference
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.selectedCountryCode = selectedCountryCode
        pickerView.delegate = self.delegate
        
    }
    
}