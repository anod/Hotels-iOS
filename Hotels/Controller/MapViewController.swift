//
//  MapViewController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 6/11/15.
//  Copyright (c) 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, EtbApiDelegate, AutocompleteDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate, HotelDetailsControllerDelegate, HotelDetailsCollectionViewControllerDataSource, UIPopoverPresentationControllerDelegate, PersonsPickerControllerDelegate, CalendarViewControllerDelegate, FiltersControllerDelegate, CLLocationManagerDelegate {

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
    
    var popoverHotelDetailsController: HotelDetailsController!
    var priceRender: PriceRender!
    
    var locationManager: CLLocationManager!
    
    let formatter = NSDateIntervalFormatter()
    let cSpan:CLLocationDegrees = 0.06 // zoom 5/111

      // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = NSDateIntervalFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateIntervalFormatterStyle.NoStyle
        
        let currency = NSLocale.currentLocale().objectForKey(NSLocaleCurrencyCode) as! String
        
        request = SearchRequest()
        // Amsterdam, default location
        request.lat = 52.3702157
        request.lon = 4.8951679
        request.type = "spr"
        request.currency = currency
        
        datesTitleView.setTitle(formatter.stringFromDate(request.checkInDate, toDate: request.checkOutDate), forState: UIControlState.Normal)
        
        priceRender = PriceRender(currencyCode: request.currency, short: true)
        
        mapView.delegate = self
        
        updateMapLocation(false)
     
        api = ApiUtils.create()
        api.delegate = self
               
        self.hotelDetailsCollection.backView = mapView
        self.hotelDetailsCollection.dataSource = self
        self.hotelDetailsCollection.delegate = self
        self.hotelDetailsCollection.controllerDataSource = self
        self.hotelDetailsCollection.containerViewController = self
        
        autocomplete = AutocompleteViewController(autocompleteResults: autocompleteResults, toolbar: toolbar)
        autocomplete.delegate = self

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if detectLocation() {
            requestAvailability()
        }
    }

    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PersonsController" {
            let vc = segue.destinationViewController as! PersonsPickerController
            vc.delegate = self
            vc.selectedValue = request.persons()
        } else if segue.identifier == "CalendarController" {
            let vc = segue.destinationViewController as! CalendarViewController
            vc.delegate = self
            vc.checkInDate = request.checkInDate
            vc.checkOutDate = request.checkOutDate
        } else if segue.identifier == "FiltersController" {
            let vc = segue.destinationViewController as! FiltersController
            vc.setRequest(request)
            vc.delegate = self
        }
    }
    
    // MARK: Methods
    
    func detectLocation() -> Bool {
        let aStatus = CLLocationManager.authorizationStatus()
        if  aStatus == CLAuthorizationStatus.Denied ||
            aStatus == CLAuthorizationStatus.Restricted {
                //app is not permitted to use location services and you should abort your attempt to use them
                return false;
        }
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        if aStatus == CLAuthorizationStatus.NotDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            self.locationManager.startUpdatingLocation()
            return true
        }
        return false
    }
    
    func updateMapLocation(animated: Bool) {
        let location = CLLocationCoordinate2D(latitude: request.lat, longitude: request.lon)
        let span = MKCoordinateSpanMake(cSpan, cSpan)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: animated)
    }
    
    func requestAvailability() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.search(request,offset: 0,limit: 50)
    }
    
    // MARK: CalendarViewControllerDelegate
    
    func didDateUpdateWithCheckIn(checkIn: NSDate, checkOut: NSDate) {
        request.checkInDate = checkIn
        request.checkOutDate = checkOut
     
        datesTitleView.setTitle(formatter.stringFromDate(request.checkInDate, toDate: request.checkOutDate), forState: UIControlState.Normal)
        requestAvailability()

    }
    
    // MARK: FiltersControllerDelegate

    func filtersDidChange(stars: Set<Int>, ratings: Set<Int>, accTypes: Set<Int>, mainFacilities: Set<Int>) {
        request.stars = stars
        request.ratings = ratings
        request.accTypes = accTypes
        request.mainFacilities = mainFacilities
        
        requestAvailability()
    }
    
    // MARK: PersonsPickerControllerDelegate
    
    func didSelectPersons(value: Int) {
        request.capacity = [value]
        personsTitleView.setTitle(String(value), forState: UIControlState.Normal)
        requestAvailability()
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        request.lon = userLocation.coordinate.longitude;
        request.lat = userLocation.coordinate.latitude;
        
        updateMapLocation(false)
        requestAvailability()
    }

    // MARK: EtbApiDelegate
   
    func searchSuccessResult(result:AccommodationsResults) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        for accomodation in result.accommodations {
            let annotation = AccommodationMKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(accomodation.location.lat, accomodation.location.lon)
            annotation.accommodation = accomodation
            //annotation.title = accomodation.name
            self.mapView.addAnnotation(annotation)
        }
    }

    func searchErrorResult(error:NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        ErrorAlertView.show("Search failed. Please try again", controller: self)
        print(error)
    }
    
    // MARK: HotelDetailsControllerDelegate
    
    func unpinHotelDetailsController(controller : HotelDetailsController) {
        print("unpinHotelDetailsController")
        let idx = self.pinnedHotels.indexOf({ element in
            return controller.accommodation.id == element.id
        })
        self.pinnedHotels.removeAtIndex(idx!)
        self.hotelDetailsCollection.deleteItemsAtIndexPaths([NSIndexPath(forItem: idx!, inSection: 0)])
    }
    
    func pinHotelDetailsController(controller : HotelDetailsController) {
        
        print("pinHotelDetailsController")
        self.popoverHotelDetailsController.dismissViewControllerAnimated(true, completion: nil)
        self.pinnedHotels.append(controller.accommodation)
        self.hotelDetailsCollection.insertItemsAtIndexPaths([NSIndexPath(forItem: self.pinnedHotels.count - 1, inSection: 0)])
    }

    // MARK: AutocompleteDelegate
    
    func didPlaceSelected(place: GooglePlaceDetails)
    {
        request.lat = place.latitude
        request.lon = place.longitude
        
        updateMapLocation(true)
        
        requestAvailability()
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        let annotation = annotation as! AccommodationMKPointAnnotation

        
        if  let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) {
            pinView.annotation = annotation

            let priceLabel = pinView.subviews[0] as! PriceLabel
            
            priceLabel.text=" " + priceRender.render(annotation.accommodation.rates[0]) + "  "
            priceLabel.sizeToFit()
            pinView.frame = priceLabel.frame

            return pinView
        }
        
        
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
       
        let priceLabel = PriceLabel()
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
        
        let navController : UINavigationController = ControllerUtils.instantiate("HotelDetailsNavController")
        
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

    // MARK: UICollectionViewDelegate
    
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

        print("cellForItemAtIndexPath, Item: \(indexPath.item), Name: \(accommodation.name)")

        
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
        print("didEndDisplayingCell")
        self.hotelDetailsCollection.didEndDisplayingCell(cell)
    }
    
    func collectionView(view: UICollectionView, controllerForIdentifier identifier: String) -> UIViewController {
        print("controllerForIdentifier")

        let vc : UINavigationController = ControllerUtils.instantiate("HotelDetailsNavController")
        return vc
    }
    
    // MARK: UIPopoverPresentationControllerDelegate
   
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController)
    {
        if selectedAnnotation != nil {
            self.mapView.deselectAnnotation(selectedAnnotation, animated: false)
            selectedAnnotation = nil
        }
    }
}

