//
//  HotelDetailsController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/18/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import Haneke

protocol HotelDetailsControllerDelegate:NSObjectProtocol {
    func unpinHotelDetailsController(controller : HotelDetailsController)
    func pinHotelDetailsController(controller : HotelDetailsController)
}

class HotelDetailsController: UITableViewController, EtbApiDelegate{

    weak var delegate: HotelDetailsControllerDelegate?
    var pinned = false
    var accommodation: Accommodation!
    var rateId: String!
    var availabilityRequest: AvailabilityRequest!
    var api: EtbApi!
    
    var heightCache = [String: CGFloat]()
    var isPinned = false
    var cheapestRate: String!
    
    var cells = [
            "HotelDetailsFacilities",
            "HotelDetailsReviews",
            "HotelDetailsRoom",
            "HotelDetailsDescription"
    ]
    
    override func viewDidLoad() {
        print("HotelDetailsController.viewDidLoad")
        super.viewDidLoad()
        
        self.setupHeader()

        
        let pinButton = UIBarButtonItem(image: UIImage(named: "Pin")!, style:UIBarButtonItemStyle.Plain, target: self, action: Selector("pinAction"))
        pinButton.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = pinButton

        tableView.allowsSelection = false
        

    }
    
    override func viewWillAppear(animated: Bool) {
        print("HotelDetailsController.viewWillAppear")
        super.viewWillAppear(animated)
        
        cheapestRate = self.accommodation.rates[0].rateId
        
        api = ApiUtils.create()
        api.delegate = self
        api.details(self.accommodation.id, request: self.availabilityRequest)
        
        let bar = self.navigationController?.navigationBar
        bar!.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar!.shadowImage = UIImage()
        
        let header = self.tableView.tableHeaderView as! ParallaxHeaderView
        header.layoutHeaderViewForScrollViewOffset(CGPointMake(0,-64))
        self.tableView.tableHeaderView = header
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BookingScreenSegue" {
            let bsController = segue.destinationViewController as! BookingScreenController
            bsController.accomodation = accommodation
            bsController.rateId = rateId
            bsController.availabilityRequest = availabilityRequest
        }
    }
    
    func detailsSuccessResult(result:AccommodationDetails) {
        
        if (result.accommodation == nil || result.accommodation.rates.isEmpty) {
            // TODO: Handle no avaialbility
            return
        }
        
        let currencyCode = availabilityRequest.currency
        
        let rate = AccommodationUtils.findRate(rateId, accommodation: accommodation)
        
        if rate == nil {
            print("rate \(rateId) not found")
            let cheapestRate = AccommodationUtils.findCheapest(accommodation, currencyCode: currencyCode)
            if cheapestRate == nil {
                // TODO: Show no avialbility message
            } else {
                rateId = cheapestRate!.rateId
                print("Showing cheapest rate instead")
                // TODO highlight changes
            }
        }
        
        let mainFacilities = self.accommodation.mainFacilities
        self.accommodation = result.accommodation
        // Missing info from details response
        self.accommodation.mainFacilities = mainFacilities
        
        if self.accommodation.details.hasCheckInPolicy()  {
            self.cells.append("HotelDetailsCheckInPolicy")
        }
        
        if (self.accommodation.details.importantInfo?.isEmpty == false) {
            self.cells.append("HotelDetailsImportantInformation")
        }

        self.cells.append("HotelDetailsPetsPolicy")

        self.cells.append("HotelDetailsAddress")

        
        self.tableView.reloadData()
        
    }

    func detailsErrorResult(error:NSError) {
        ErrorAlertView.show("Availability request failed. Please try again", controller: self)
        print(error)
    }
    
    
    func setupHeader() {
        let parallaxHeader = ParallaxHeaderView.parallaxHeaderViewWithImage(UIImage(named: "hotel_placeholder"), forSize: CGSizeMake(260, 139)) as! ParallaxHeaderView
        
        let headerView = HotelDetailsHeader.loadFromNib()
        headerView.attach(self.accommodation, rateId: rateId, availabilityRequest: availabilityRequest)
        
        parallaxHeader.addSubview(headerView)

        
        self.tableView.tableHeaderView = parallaxHeader;

        if (self.accommodation.images.count > 0) {
            let URL = NSURL(string: self.accommodation.images[0])!
            
            parallaxHeader.imageView!.hnk_setImageFromURL(URL, placeholder: nil, format: nil, failure: nil, success: self.imageLoadSuccess)
            
            let tap = UITapGestureRecognizer(target:self, action:"openPhotoBrowser")
            tap.numberOfTapsRequired = 1;
            tap.enabled = true;
            tap.cancelsTouchesInView = false;
            parallaxHeader.addGestureRecognizer(tap)
            
        }
        
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
            self.delegate!.unpinHotelDetailsController(self)
        } else {
            self.delegate!.pinHotelDetailsController(self)
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
        let hdCell = cell as! AccommodationViewProtocol
        hdCell.attach(self.accommodation, rateId: rateId, availabilityRequest: availabilityRequest)
        return cell
    }
    
    func cellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
        return cells[indexPath.item]
    }
    
    func openPhotoBrowser() {

        let browser = PhotoBrowser(photos: self.accommodation.images, caption: self.accommodation.name!, animatedFromView:self.tableView.tableHeaderView)
        self.presentViewController(browser, animated:true, completion: nil)
    }
    

}
