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
    
    var stars: Set<Int>!
    var ratings: Set<Int>!
    var accTypes: Set<Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        starsFilter.selectedSegmentIndexes = convertToIndexSet(stars)
        ratingFilter.selectedSegmentIndexes = convertToIndexSet(ratings)
        starsFilter.selectedSegmentIndexes = convertToIndexSet(accTypes)

    }

    func convertToIndexSet(sourceSet: Set<Int>) -> NSIndexSet {
        let indexSet = NSMutableIndexSet()
        for value in sourceSet {
            indexSet.addIndex(value - 1)
        }
        return indexSet
    }
    
    func setRequest(request: SearchRequest) {
        stars = request.getStars()
        ratings = request.getRating()
        accTypes = request.getAccTypes()
    }
}