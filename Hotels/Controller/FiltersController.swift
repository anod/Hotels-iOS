//
//  FiltersController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/11/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

protocol FiltersControllerDelegate: NSObjectProtocol {
	   func filtersDidChange(stars: Set<Int>, ratings: Set<Int>, accTypes: Set<Int>, mainFacilities: Set<Int>)
}
class FiltersController: UITableViewController, MultiSelectSegmentedControlDelegate {
    
    @IBOutlet weak var typeFilter: MultiSelectSegmentedControl!
    @IBOutlet weak var ratingFilter: MultiSelectSegmentedControl!
    @IBOutlet weak var starsFilter: MultiSelectSegmentedControl!
    @IBOutlet weak var faciltiesFilter: MultiSelectSegmentedControl!
    
    var stars: Set<Int>!
    var ratings: Set<Int>!
    var accTypes: Set<Int>!
    var mainFacilities: Set<Int>!
    
    weak var delegate: FiltersControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        starsFilter.selectedSegmentIndexes = convertToIndexSet(stars)
        ratingFilter.selectedSegmentIndexes = convertToIndexSet(ratings)
        //typeFilter.selectedSegmentIndexes = convertToIndexSet(accTypes)

        starsFilter.delegate = self
        ratingFilter.delegate = self
        typeFilter.delegate = self
        faciltiesFilter.delegate = self

    }

    func convertToIndexSet(sourceSet: Set<Int>) -> NSIndexSet {
        let indexSet = NSMutableIndexSet()
        for value in sourceSet {
            indexSet.addIndex(value - 1)
        }
        return indexSet
    }
    
    func setRequest(request: SearchRequest) {
        stars = request.stars
        ratings = request.ratings
        accTypes = request.accTypes
        mainFacilities = request.mainFacilities
    }
    
    func multiSelect(multiSelecSegmendedControl: MultiSelectSegmentedControl!, didChangeValue value: Bool, atIndex index: UInt) {
        // TODO
    }
}