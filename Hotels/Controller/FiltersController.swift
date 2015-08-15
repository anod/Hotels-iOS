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
    
    var stars: [Int]!
    var ratings: [Int]!
    var accTypes: [Int]!
    
    func attach(accommodation: Accommodation) {
    	
    
    }
}