//
//  ExpirationPickerController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/13/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class ExpirationPickerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerView: UIPickerView!
    
    var titles = [[String](), [String]()]
    var values: [[Int]]!
    
    var selectedValue: Int!
    //weak var delegate: PersonsPickerControllerDelegate? // default is nil. weak reference
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        values = [
            [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ],
            []
        ]
        
        let df = NSDateFormatter()
        
        let cal = NSCalendar.currentCalendar()
        let components = cal.components([NSCalendarUnit.Year, NSCalendarUnit.Month], fromDate: NSDate())
        
        for idx in 0...11 {
            titles[0].append(df.monthSymbols[idx])
        }
        for idx in 0...19 {
            let year = components.year + idx
            values[1].append(year)
            titles[1].append(String(year))
        }
        setPickerValue(components.month, inComponent: 0)
        setPickerValue(components.year, inComponent: 1)

    }
    
    
    func setPickerValue(value: Int, inComponent component: Int) {
        let row = values[component].indexOf(value)
        pickerView.selectRow(row!, inComponent: component, animated: false)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titles[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //delegate!.onSelectPersons(values[component][row])
    }
}