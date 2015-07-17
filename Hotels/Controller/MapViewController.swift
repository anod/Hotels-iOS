//
//  MapViewController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 6/11/15.
//  Copyright (c) 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, EtbApiDelegate, AutocompleteDelegate, GMSMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var mapContainer: GMSMapView!
    @IBOutlet weak var autocompleteResults: UITableView!
    @IBOutlet weak var autocompleteContainer: UIView!
    @IBOutlet weak var hotelDetailsCollection: HotelDetailsCollectionView!
    
    var request: SearchRequest!
    var api: EtbApi!
    var autocomplete: AutocompleteViewController!
    var pinnedHotels: [Accommodation] = []
    var currentHotel: Accommodation! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        request = SearchRequest()
        request.lat = -33.86
        request.lon = 151.20
        request.type = "spr"
        
        let camera = GMSCameraPosition.cameraWithLatitude(request.lat, longitude: request.lon, zoom: 13)
        mapContainer.camera = camera;
        mapContainer.myLocationEnabled = true
        mapContainer.delegate = self
        
        autocomplete = AutocompleteViewController(autocompleteResults: autocompleteResults, autocompleteContainer: autocompleteContainer)
        autocomplete.delegate = self


        let apiConfig = EtbApiConfig(apiKey: "SMXSJLLNOJida")
        api = EtbApi(config: apiConfig)
        api.delegate = self
        
        self.hotelDetailsCollection.backView = mapContainer
        self.hotelDetailsCollection.dataSource = self
        self.hotelDetailsCollection.delegate = self
        self.hotelDetailsCollection.registerNib(UINib(nibName: "HotelDetailsView", bundle: NSBundle(forClass: HotelDetailsView.self)), forCellWithReuseIdentifier: "HotelDetailsView")

    }
    
   
    override func viewDidAppear(animated: Bool) {
        api.search(request,offset: 0,limit: 15)
    }

    func searchSuccessResult(result:AccomodationsResults) {
        
        
        for accomodation in result.accommodations {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(accomodation.location.lat, accomodation.location.lon)
            marker.icon = GMSMarker.markerImageWithColor(UIColor.orangeColor())
//            marker.title = accomodation.name
//            marker.snippet = accomodation.summary.address
            marker.map = self.mapContainer
            marker.userData = accomodation;
        }

    }

    func searchErrorResult(error:NSError) {
        print(error)
    }

    
    func onPlaceSelected(place: GMSPlace)
    {
        let coord = place.coordinate;
        
        let camera = GMSCameraPosition.cameraWithLatitude(coord.latitude, longitude: coord.longitude, zoom: 13)
        mapContainer.camera = camera;
        
        request.lat = coord.latitude
        request.lon = coord.longitude
        
        self.mapContainer.clear()
        
        api.search(request,offset: 0,limit: 15)
    }

    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        
        let accomodation = marker.userData as! Accommodation
  
        self.currentHotel = accomodation;
        self.hotelDetailsCollection.reloadData()
        
//        let frame = CGRectMake(16, 300, 320, 320)
//        
//        self.accomodationView = HotelDetailsView.instanceFromNib()
//        self.accomodationView.frame = frame
//        self.accomodationView.accomodation = accomodation;
        
//        self.view.addSubview(accomodationView)
        
        return true
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
        return self.pinnedHotels.count + (self.currentHotel != nil ? 1 : 0)
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let hotelDetailsView = collectionView.dequeueReusableCellWithReuseIdentifier("HotelDetailsView", forIndexPath: indexPath) as! HotelDetailsView
        hotelDetailsView.userInteractionEnabled = true
        
        if (self.pinnedHotels.count > 0 && self.pinnedHotels.count < indexPath.row) {
            let accomodation = self.pinnedHotels[indexPath.row];
            hotelDetailsView.attach(accomodation)
        } else if (indexPath.row == self.pinnedHotels.count && self.currentHotel != nil) {
            hotelDetailsView.attach(self.currentHotel)
        }
        return hotelDetailsView
    }
}

