//
//  FiltersController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/11/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation
class FiltersController: UITableViewController {
    
    @IBOutlet weak var typeFilter: UISegmentedControl!
    @IBOutlet weak var ratingFilter: UISegmentedControl!
    @IBOutlet weak var starsFilter: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        starsFilter.setImage(starsImage, forSegmentAtIndex: 2)
    }
}