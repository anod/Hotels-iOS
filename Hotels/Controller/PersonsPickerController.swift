//
//  PersonsPickerController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/11/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

protocol PersonsPickerControllerDelegate {
    func personsChanged(persons: Int)
}

class PersonsPickerController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var personsPicker: UIPickerView!
    
    var persons = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personsPicker.delegate = self
        personsPicker.dataSource = self
        
        personsPicker.selectRow(persons - 1, inComponent: 0, animated: false)
        
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "1 Guest" : "\(row+1) Guests"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}