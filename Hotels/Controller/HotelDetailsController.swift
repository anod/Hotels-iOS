//
//  HotelDetailsController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/18/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import IDMPhotoBrowser

protocol HotelDetailsViewProtocol {
    
    func attach(accomodation: Accommodation)
}

protocol HotelDetailsControllerDelegate {
    func unpinHotelDetailsController(controller : HotelDetailsController)
    func pinHotelDetailsController(controller : HotelDetailsController)
}

class HotelDetailsController: UITableViewController, HotelDetailsHeaderDelegate{

    var delegate: HotelDetailsControllerDelegate!
    var pinned = false
    var accommodation: Accommodation!
    
    var heightCache = [String: CGFloat]()
    var isPinned = false
    var pinIndex = 0
    
    let cells = [
        "HotelDetailsFacilities",
        "HotelDetailsReviews",
        "HotelDetailsRoom",
        "HotelDetailsDescription"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let headerView = self.tableView.tableHeaderView as! HotelDetailsHeader;
        headerView.attach(self.accommodation)
        headerView.delegate = self
        headerView.pinButton.selected = self.isPinned
        
        
    }
    
    func headerReady(image: UIImage) {
        print("header ready")

    }

    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.tableView {
            var rect = self.tableView.tableHeaderView!.frame;
            rect.origin.y = min(0, self.tableView.contentOffset.y);
            self.tableView.tableHeaderView!.frame = rect;
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = self.cellIdentifierForIndexPath(indexPath)
        let cell = self.createTableCell(tableView, identifier: identifier)

//        if identifier == "HotelDetailsHeader" {
//            let cell = cell as! HotelDetailsHeader
//            cell.delegate = self
//            cell.pinButton.selected = self.isPinned
//        }
        
        return cell;
    }

    
    func pinAction() {
        if isPinned {
            self.delegate.unpinHotelDetailsController(self)
        } else {
            self.delegate.pinHotelDetailsController(self)
        }
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
        hdCell.attach(self.accommodation)
        return cell
    }
    
    func cellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
        return cells[indexPath.item]
    }
    
    func openPhotoBrowser() {
        var urlsArray = [NSURL]()
        for imageStrUrl in self.accommodation.images {
            urlsArray.append(NSURL(string: imageStrUrl)!)
        }
        let photosWithURL = IDMPhoto.photosWithURLs(urlsArray)
        let browser = IDMPhotoBrowser(photos: photosWithURL, animatedFromView:self.tableView.tableHeaderView)
        browser.displayCounterLabel = true
        browser.displayActionButton = false
        self.presentViewController(browser, animated:true, completion: nil)
    }


}
