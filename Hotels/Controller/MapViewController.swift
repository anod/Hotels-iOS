//
//  MapViewController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 6/11/15.
//  Copyright (c) 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, EtbApiDelegate, AutocompleteDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate, HotelDetailsControllerDelegate, HotelDetailsCollectionViewControllerDataSource, UIPopoverPresentationControllerDelegate, PersonsPickerControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var autocompleteResults: UITableView!
    @IBOutlet weak var hotelDetailsCollection: HotelDetailsCollectionView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var datesTitleView: UIButton!
    
    @IBOutlet weak var personsTitleView: UIButton!
    
    var request: SearchRequest!
    var api: EtbApi!
    var autocomplete: AutocompleteViewController!
    var pinnedHotels: [Accommodation] = []
    var currentHotel: Accommodation! = nil
    var selectedAnnotation: AccommodationMKPointAnnotation!
    
    var currency = "EUR"
    var popoverHotelDetailsController: HotelDetailsController!
    var priceRender: PriceRender!
    
    let cSpan:CLLocationDegrees = 0.09 // zoom 5/111

    override func viewDidLoad() {
        super.viewDidLoad()


        request = SearchRequest()
        request.lat = -33.86
        request.lon = 151.20
        request.type = "spr"
        request.currency = currency
        
        priceRender = PriceRender(currencyCode: currency, short: true)
        
        mapView.delegate = self
        
        updateMapLocation(false)
     
        api = ApiUtils.create()
        api.delegate = self
               
        self.hotelDetailsCollection.backView = mapView
        self.hotelDetailsCollection.dataSource = self
        self.hotelDetailsCollection.delegate = self
        self.hotelDetailsCollection.controllerDataSource = self
        self.hotelDetailsCollection.containerViewController = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        autocomplete = AutocompleteViewController(autocompleteResults: autocompleteResults, toolbar: toolbar)
        autocomplete.delegate = self

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PersonsController" {
            let vc = segue.destinationViewController as! PersonsPickerController
            vc.delegate = self
            vc.selectedValue = request.persons()
        }
    }
    
    func onSelectPersons(value: Int) {
        request.capacity = [value]
        personsTitleView.setTitle(String(value), forState: UIControlState.Normal)
        requestAvailability()
    }
    
    func updateMapLocation(animated: Bool) {
        let location = CLLocationCoordinate2D(latitude: request.lat, longitude: request.lon)
        let span = MKCoordinateSpanMake(cSpan, cSpan)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: animated)
    }
    
   
    override func viewDidAppear(animated: Bool) {
        requestAvailability()
    }

    func requestAvailability() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        

        api.search(request,offset: 0,limit: 50)
    }
    
    func searchSuccessResult(result:AccommodationsResults) {
        
        for accomodation in result.accommodations {
            let annotation = AccommodationMKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(accomodation.location.lat, accomodation.location.lon)
            annotation.accommodation = accomodation
            //annotation.title = accomodation.name
            self.mapView.addAnnotation(annotation)
        }
    }

    func searchErrorResult(error:NSError) {
        ErrorAlertView.show("Search failed. Please try again", controller: self)
        print(error)
    }

    
    func onPlaceSelected(place: GooglePlaceDetails)
    {
        
        request.lat = place.latitude
        request.lon = place.longitude
        
        updateMapLocation(true)
        
        requestAvailability()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        let annotation = annotation as! AccommodationMKPointAnnotation

        
        if  let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) {
            pinView.annotation = annotation

            let priceLabel = pinView.subviews[0] as! ALabel
            
            priceLabel.text=" " + priceRender.render(annotation.accommodation.rates[0]) + "  "
            priceLabel.sizeToFit()
            pinView.frame = priceLabel.frame

            return pinView
        }
        
        
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
       
        let priceLabel = ALabel(frame: CGRectMake(0,0,50,21))
        priceLabel.font=UIFont(name: "Avenir Next Regular", size: 14)
        priceLabel.textAlignment=NSTextAlignment.Left;
        priceLabel.textColor=UIColor.whiteColor()
        priceLabel.userInteractionEnabled = true
        priceLabel.backgroundColor=UIColor.orangeColor()
        
        priceLabel.layer.cornerRadius = 8;
        priceLabel.clipsToBounds = true
        priceLabel.lineBreakMode = NSLineBreakMode.ByClipping
        
        priceLabel.text=" " + priceRender.render(annotation.accommodation.rates[0]) + "  "
        priceLabel.sizeToFit()
        
        pinView.frame = priceLabel.frame
        
        pinView.addSubview(priceLabel)
        
        return pinView;
        
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let annotation = view.annotation as! AccommodationMKPointAnnotation
        let accommodation = annotation.accommodation
  
        selectedAnnotation = annotation
        
        let navController = instantiateHotelDetailsViewController();
        
        popoverHotelDetailsController = navController.viewControllers[0] as! HotelDetailsController
        popoverHotelDetailsController.accommodation = accommodation
        popoverHotelDetailsController.rateId = accommodation.rates[0].rateId
        popoverHotelDetailsController.availabilityRequest = request
        popoverHotelDetailsController.delegate = self
        popoverHotelDetailsController.preferredContentSize = CGSizeMake(260,360)
        
        navController.modalPresentationStyle = .Popover
        
        let hdPopoverController = navController.popoverPresentationController
        hdPopoverController?.permittedArrowDirections = .Any
        hdPopoverController?.sourceView = view
        hdPopoverController?.sourceRect = view.bounds
        hdPopoverController?.delegate = self
        presentViewController(navController,animated: true, completion: nil)
    }
    
    func mainStoryboard() -> UIStoryboard
    {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pinnedHotels.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        

        let hotelDetailsCell = collectionView.dequeueReusableCellWithReuseIdentifier("HotelDetailsCell", forIndexPath: indexPath) as! HotelDetailsCell

        let accommodation = self.pinnedHotels[indexPath.item];
        let nav = hotelDetailsCell.contentViewController as! UINavigationController
        let vc = nav.viewControllers[0] as! HotelDetailsController
        vc.accommodation = accommodation
        vc.availabilityRequest = request
        vc.rateId = accommodation.rates[0].rateId
        vc.isPinned = true
        vc.delegate = self
        
        return hotelDetailsCell
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        self.hotelDetailsCollection.didEndDisplayingCell(cell)
    }
    
    func collectionView(view: UICollectionView, controllerForIdentifier identifier: String) -> UIViewController {
        let vc = instantiateHotelDetailsViewController()
        
        return vc
    }
    
    func instantiateHotelDetailsViewController() -> UINavigationController {
        return mainStoryboard().instantiateViewControllerWithIdentifier("HotelDetailsNavController") as! UINavigationController
    }
    
    func unpinHotelDetailsController(controller : HotelDetailsController) {
        let idx = self.pinnedHotels.indexOf(controller.accommodation)
        self.pinnedHotels.removeAtIndex(idx!)
        self.hotelDetailsCollection.reloadData()
    }
    
    func pinHotelDetailsController(controller : HotelDetailsController) {
        
        self.popoverHotelDetailsController.dismissViewControllerAnimated(true, completion: nil)
        self.pinnedHotels.append(controller.accommodation)
        self.hotelDetailsCollection.reloadData()
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController)
    {
        if selectedAnnotation != nil {
            self.mapView.deselectAnnotation(selectedAnnotation, animated: false)
            selectedAnnotation = nil
        }
    }
}

