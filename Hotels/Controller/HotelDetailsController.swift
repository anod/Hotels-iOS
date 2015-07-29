//
//  HotelDetailsController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/18/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import IDMPhotoBrowser
import Haneke

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

        
        let parallaxHeader = ParallaxHeaderView.parallaxHeaderViewWithImage(UIImage(named: "hotel_placeholder.png"), forSize: CGSizeMake(260, 139)) as! ParallaxHeaderView
        
        let headerView = HotelDetailsHeader.loadFromNib()
        headerView.attach(self.accommodation)
        headerView.delegate = self
        headerView.pinButton.selected = self.isPinned
        
        parallaxHeader.addSubview(headerView)
        
        if (self.accommodation.images.count > 0) {
            let URL = NSURL(string: self.accommodation.images[0])!
            
            parallaxHeader.imageView!.hnk_setImageFromURL(URL, placeholder: nil, format: nil, failure: nil, success: self.imageLoadSuccess)
        }

        let tap = UITapGestureRecognizer(target:self, action:"openPhotoBrowser")
        tap.numberOfTapsRequired = 1;
        tap.enabled = true;
        tap.cancelsTouchesInView = false;
        parallaxHeader.addGestureRecognizer(tap)
        
        self.tableView.tableHeaderView = parallaxHeader;

    }
    
    func imageLoadSuccess(image: UIImage) -> () {
        let parallaxHeader = self.tableView.tableHeaderView as! ParallaxHeaderView
        let animated = true
        let duration : NSTimeInterval = animated ? 0.1 : 0
        
        UIView.transitionWithView(parallaxHeader.imageView!, duration: duration, options: .TransitionCrossDissolve, animations: {
            parallaxHeader.headerImage = image
         }, completion: nil)
    }
    
   
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.tableView {
            let header = self.tableView.tableHeaderView as! ParallaxHeaderView
            header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
            print(scrollView.contentOffset)
            self.tableView.tableHeaderView = header
            if scrollView.contentOffset.y < -100 {
                openPhotoBrowser()
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = self.cellIdentifierForIndexPath(indexPath)
        let cell = self.createTableCell(tableView, identifier: identifier)
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
