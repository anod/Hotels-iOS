//
//  MapViewController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 6/11/15.
//  Copyright (c) 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class MapViewController: UIViewController, EtbApiDelegate, AutocompleteDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate, HotelDetailsControllerDelegate,HotelDetailsCollectionViewControllerDataSource {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var autocompleteResults: UITableView!
    @IBOutlet weak var autocompleteContainer: UIView!
    @IBOutlet weak var hotelDetailsCollection: HotelDetailsCollectionView!
    
    var request: SearchRequest!
    var api: EtbApi!
    var autocomplete: AutocompleteViewController!
    var pinnedHotels: [Accommodation] = []
    var currentHotel: Accommodation! = nil
    
    var currency = "EUR"
    var popoverHotelDetailsController: HotelDetailsController!
    
    let cSpan:CLLocationDegrees = 0.09 // zoom 5/111

    override func viewDidLoad() {
        super.viewDidLoad()


        request = SearchRequest()
        request.lat = -33.86
        request.lon = 151.20
        request.type = "spr"
        request.currency = currency
        
        mapView.delegate = self
        
        updateMapLocation(false)

        autocomplete = AutocompleteViewController(autocompleteResults: autocompleteResults, autocompleteContainer: autocompleteContainer)
        autocomplete.delegate = self

        let apiConfig = EtbApiConfig(apiKey: "SMXSJLLNOJida")
        api = EtbApi(config: apiConfig)
        api.delegate = self
        
        self.hotelDetailsCollection.backView = mapView
        self.hotelDetailsCollection.dataSource = self
        self.hotelDetailsCollection.delegate = self
        self.hotelDetailsCollection.controllerDataSource = self
        self.hotelDetailsCollection.containerViewController = self
    }
    
    func updateMapLocation(animated: Bool) {
        let location = CLLocationCoordinate2D(latitude: request.lat, longitude: request.lon)
        let span = MKCoordinateSpanMake(cSpan, cSpan)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: animated)
    }
    
   
    override func viewDidAppear(animated: Bool) {
        api.search(request,offset: 0,limit: 15)
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
        print(error)
    }

    
    func onPlaceSelected(place: GMSPlace)
    {
        let coord = place.coordinate;
        
        request.lat = coord.latitude
        request.lon = coord.longitude
        
        updateMapLocation(true)
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        api.search(request,offset: 0,limit: 15)
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
            
            priceLabel.text=annotation.accommodation.rates[0].payment.prepaid[currency]
            priceLabel.sizeToFit()
            pinView.frame = priceLabel.frame

            return pinView
        }
        
        
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
       
        let priceLabel = ALabel(frame: CGRectMake(0,0,50,21))
        priceLabel.font=UIFont(name: "Avenir Next Regular", size: 14)
        priceLabel.textAlignment=NSTextAlignment.Center;
        priceLabel.textColor=UIColor.whiteColor()
        priceLabel.userInteractionEnabled = true
        priceLabel.backgroundColor=UIColor.orangeColor()
        
        priceLabel.layer.cornerRadius = 8;
        priceLabel.clipsToBounds = true
        priceLabel.lineBreakMode = NSLineBreakMode.ByClipping
        
        
        priceLabel.text=annotation.accommodation.rates[0].payment.prepaid[currency]
        priceLabel.sizeToFit()
        
        pinView.frame = priceLabel.frame
        
        pinView.addSubview(priceLabel)
        
        return pinView;
        
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let annotation = view.annotation as! AccommodationMKPointAnnotation
        let accommodation = annotation.accommodation
  
        self.popoverHotelDetailsController = instantiateHotelDetailsViewController();
        self.popoverHotelDetailsController.accommodation = accommodation
        self.popoverHotelDetailsController.availaibilityRequest = request
        self.popoverHotelDetailsController.modalPresentationStyle = .Popover
        self.popoverHotelDetailsController.preferredContentSize = CGSizeMake(260,360)
        self.popoverHotelDetailsController.delegate = self
        let hdPopoverController = self.popoverHotelDetailsController.popoverPresentationController
        hdPopoverController?.permittedArrowDirections = .Any
        hdPopoverController?.sourceView = view
        hdPopoverController?.sourceRect = view.bounds
        presentViewController(self.popoverHotelDetailsController,animated: true, completion: nil)
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
        let vc = hotelDetailsCell.contentViewController as! HotelDetailsController
        vc.accommodation = accommodation
        vc.availaibilityRequest = request
        vc.isPinned = true
        vc.pinIndex = indexPath.item
        vc.delegate = self
        return hotelDetailsCell
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        self.hotelDetailsCollection.didEndDisplayingCell(cell)
    }
    
    func collectionView(view: UICollectionView, controllerForIdentifier identifier: String) -> UIViewController {
        return instantiateHotelDetailsViewController()
    }
    
    func instantiateHotelDetailsViewController() -> HotelDetailsController {
        return mainStoryboard().instantiateViewControllerWithIdentifier("HotelDetailsViewController") as! HotelDetailsController
    }
    
    func unpinHotelDetailsController(controller : HotelDetailsController) {
        self.pinnedHotels.removeAtIndex(controller.pinIndex)
        self.hotelDetailsCollection.reloadData()
    }
    
    func pinHotelDetailsController(controller : HotelDetailsController) {
        self.popoverHotelDetailsController.dismissViewControllerAnimated(true, completion: nil)
        self.pinnedHotels.append(controller.accommodation)
        self.hotelDetailsCollection.reloadData()
    }
}

