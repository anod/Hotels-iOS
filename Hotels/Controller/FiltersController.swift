//
//  FiltersController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/11/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

protocol FiltersControllerDelegate {
	   func filtersDidChange(stars: [Int], ratings: [Int], accTypes: [Int])
}
class FiltersController: UITableViewController {
    
    @IBOutlet weak var typeFilter: MultiSelectSegmentedControl!
    @IBOutlet weak var ratingFilter: MultiSelectSegmentedControl!
    @IBOutlet weak var starsFilter: MultiSelectSegmentedControl!
    
    var stars: [Int]!
    var ratings: [Int]!
    var accTypes: [Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}