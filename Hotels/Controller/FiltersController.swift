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
    
    let tagStars = 0
    let tagRating = 1
    let tagType = 2
    let tagFacilities = 3
    
    let starsMap = [ 1, 2, 3, 4, 5 ]
    
    let ratingsMap = [ 1, 2, 3, 4, 5 ]
    
    let typesMap = [
        AccType.Hotel.rawValue,
        AccType.Apartment.rawValue,
        AccType.Hostel.rawValue,
        AccType.BedAndBreafast.rawValue
    ]
    
    let facilitiesMap = [
        Facility.Internet.rawValue,
        Facility.Parking.rawValue,
        Facility.PetsAllowed.rawValue,
        Facility.AirConditioning.rawValue,
        Facility.Disabled.rawValue
    ]
    
    var stars: Set<Int>!
    var ratings: Set<Int>!
    var accTypes: Set<Int>!
    var mainFacilities: Set<Int>!
    
    weak var delegate: FiltersControllerDelegate?
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        starsFilter.selectedSegmentIndexes = convertValuesToIndexSet(stars, map: starsMap)
        ratingFilter.selectedSegmentIndexes = convertValuesToIndexSet(ratings, map: ratingsMap)
        typeFilter.selectedSegmentIndexes = convertValuesToIndexSet(accTypes, map: typesMap)
        faciltiesFilter.selectedSegmentIndexes = convertValuesToIndexSet(mainFacilities, map: facilitiesMap)

        starsFilter.tag = tagStars
        ratingFilter.tag = tagRating
        typeFilter.tag = tagType
        faciltiesFilter.tag = tagFacilities
        
        starsFilter.delegate = self
        ratingFilter.delegate = self
        typeFilter.delegate = self
        faciltiesFilter.delegate = self

    }
    
    // MARK: MultiSelectSegmentedControlDelegate
    
    func multiSelect(multiSelecSegmendedControl: MultiSelectSegmentedControl!, didChangeValue value: Bool, atIndex index: UInt) {
        
        if multiSelecSegmendedControl.tag == tagStars {
            stars = convertIndexesToValues(multiSelecSegmendedControl.selectedSegmentIndexes, map: starsMap)
        } else if multiSelecSegmendedControl.tag == tagRating {
            ratings = convertIndexesToValues(multiSelecSegmendedControl.selectedSegmentIndexes, map: ratingsMap)
        } else if multiSelecSegmendedControl.tag == tagType {
            accTypes = convertIndexesToValues(multiSelecSegmendedControl.selectedSegmentIndexes, map: typesMap)
        } else if multiSelecSegmendedControl.tag == tagFacilities {
            mainFacilities = convertIndexesToValues(multiSelecSegmendedControl.selectedSegmentIndexes, map: facilitiesMap)
        }
        
        self.delegate?.filtersDidChange(stars, ratings: ratings, accTypes: accTypes, mainFacilities: mainFacilities)
        
    }
    
    // MARK: Methods
    
    func convertValuesToIndexSet(values: Set<Int>, map: [Int]) -> NSIndexSet {
        let indexSet = NSMutableIndexSet()
        
        for var index = 0; index < map.count; ++index {
            if values.contains(map[index]) {
                indexSet.addIndex(index)
            }
        }
        
        return indexSet
    }
    
    func setRequest(request: SearchRequest) {
        stars = request.stars
        ratings = request.ratings
        accTypes = request.accTypes
        mainFacilities = request.mainFacilities
    }
    
    func convertIndexesToValues(indexSet: NSIndexSet, map: [Int]) -> Set<Int> {
        var result = Set<Int>()
        
        indexSet.enumerateIndexesUsingBlock
            {
                (idx, stop) -> Void in
                
                result.insert(map[idx])
        }

        return result
    }
}