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

class MapViewController: UIViewController, EtbApiDelegate, AutocompleteDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate, HotelDetailsCollectionViewControllerDataSource {

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

    func searchSuccessResult(result:AccomodationsResults) {
        
        for accomodation in result.accommodations {
            let annotation = AccommodationMKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(accomodation.location.lat, accomodation.location.lon)
            annotation.accommodation = accomodation
            annotation.title = accomodation.name
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
            pinView.canShowCallout = true

            let priceLabel = pinView.subviews[0] as! ALabel
            
            priceLabel.text=annotation.accommodation.rates[0].payment.prepaid[currency]
            priceLabel.sizeToFit()
            pinView.frame = priceLabel.frame

            return pinView
        }
        
        
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView.canShowCallout = true
       
        let priceLabel = ALabel(frame: CGRectMake(0,0,50,21))
        priceLabel.font=UIFont(name: "Avenir Next Regular", size: 14)
        priceLabel.textAlignment=NSTextAlignment.Center;
        priceLabel.textColor=UIColor.blackColor()
        priceLabel.userInteractionEnabled = true
        priceLabel.backgroundColor=UIColor.whiteColor()
        
        priceLabel.layer.cornerRadius = 8;
        priceLabel.layer.borderColor = UIColor.greenColor().CGColor
        priceLabel.layer.borderWidth = 1.0;
        priceLabel.lineBreakMode = NSLineBreakMode.ByClipping
        
        
        priceLabel.text=annotation.accommodation.rates[0].payment.prepaid[currency]
        priceLabel.sizeToFit()
        
        pinView.frame = priceLabel.frame
        
        pinView.addSubview(priceLabel)
        
        return pinView;
        
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let annotation = view.annotation as! AccommodationMKPointAnnotation
        let accomodation = annotation.accommodation
  
        //self.currentHotel = accomodation;
        self.pinnedHotels.append(accomodation)
        self.hotelDetailsCollection.reloadData()
        
//        let frame = CGRectMake(16, 300, 320, 320)
//        
//        self.accomodationView = HotelDetailsView.instanceFromNib()
//        self.accomodationView.frame = frame
//        self.accomodationView.accomodation = accomodation;
        
//        self.view.addSubview(accomodationView)
        
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

        /*
        let hotelDetailsView = collectionView.dequeueReusableCellWithReuseIdentifier("HotelDetailsView", forIndexPath: indexPath) as! HotelDetailsView
        hotelDetailsView.userInteractionEnabled = true
        
        if (self.pinnedHotels.count > 0 && self.pinnedHotels.count < indexPath.row) {
            let accomodation = self.pinnedHotels[indexPath.row];
            hotelDetailsView.attach(accomodation)
        } else if (indexPath.row == self.pinnedHotels.count && self.currentHotel != nil) {
            hotelDetailsView.attach(self.currentHotel)
        }
*/
        let accomodation = self.pinnedHotels[indexPath.row];
        let vc = hotelDetailsCell.contentViewController as! HotelDetailsController
        vc.accomodation = accomodation
       
        return hotelDetailsCell
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        self.hotelDetailsCollection.didEndDisplayingCell(cell)
    }
    
    func collectionView(view: UICollectionView, controllerForIdentifier identifier: String) -> UIViewController {
        return mainStoryboard().instantiateViewControllerWithIdentifier("HotelDetailsViewController") as! HotelDetailsController
    }
}

