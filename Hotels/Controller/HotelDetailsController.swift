//
//  HotelDetailsController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/18/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

protocol HotelDetailsViewProtocol {
    
    func attach(accomodation: Accommodation)
}

class HotelDetailsController: UITableViewController {

    var delegate: HotelDetailsViewDelegate!
    var pinned = false
    var accomodation: Accommodation!
    
    var heightCache = [String: CGFloat]()
    
    let cells = [
        "HodelDetailsHeader",
        "HotelDetailsFacilities",
        "HotelDetailsReviews",
        "HotelDetailsRoom",
        "HotelDetailsDescription"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = self.cellIdentifierForIndexPath(indexPath)
        return self.createTableCell(tableView, identifier: identifier)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let identifier = self.cellIdentifierForIndexPath(indexPath)

        let cachedHeight = heightCache[identifier];
        if let height = cachedHeight {
            return height
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        let height = cell!.bounds.size.height
        heightCache[identifier] = height;
        return height;
    }
    func createTableCell(tableView: UITableView, identifier: String) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier)
        let hdCell = cell as! HotelDetailsViewProtocol
        hdCell.attach(self.accomodation)
        return cell
    }
    
    func cellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
        return cells[indexPath.item]
    }
}
