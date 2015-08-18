//
//  PersonsPickerController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/11/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

public protocol PersonsPickerControllerDelegate : NSObjectProtocol {
    func didSelectPersons(value: Int)
}

class PersonsPickerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerView: UIPickerView!
    
    var components = 1
    var titles = [[String]()]
    var values: [[Int]]!
    
    var selectedValue: Int!
    weak var delegate: PersonsPickerControllerDelegate? // default is nil. weak reference

    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        

        values = [
            [ 1, 2, 3, 4, 5, 6]
        ]
        
        for idx in 0...5 {
            let value = values[0][idx]
            titles[0].append(value == 1 ? "1 Guest" : "\(value) Guests")
        }
        
        setPickerValue(selectedValue, inComponent: 0)
    }

    // MARK: Methods
    
    func setPickerValue(value: Int, inComponent component: Int) {
        let row = values[component].indexOf(value)
        pickerView.selectRow(row!, inComponent: component, animated: false)
    }
    
    // MARK: UIPickerViewDelegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return components
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titles[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate!.didSelectPersons(values[component][row])
    }
}