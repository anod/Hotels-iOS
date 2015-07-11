//
//  MapViewController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 6/11/15.
//  Copyright (c) 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, EtbApiDelegate, AutocompleteDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapContainer: GMSMapView!
    @IBOutlet weak var autocompleteResults: UITableView!
    @IBOutlet weak var autocompleteContainer: UIView!
    
    var request: SearchRequest!
    var api: EtbApi!
    var autocomplete: AutocompleteViewController!

    override func viewDidLoad() {
        super.viewDidLoad()


        request = SearchRequest()
        request.lat = -33.86
        request.lon = 151.20
        request.type = "spr"
        
        let camera = GMSCameraPosition.cameraWithLatitude(request.lat, longitude: request.lon, zoom: 12)
        mapContainer.camera = camera;
        mapContainer.myLocationEnabled = true
        mapContainer.delegate = self
        
        autocomplete = AutocompleteViewController(autocompleteResults: autocompleteResults, autocompleteContainer: autocompleteContainer)
        autocomplete.delegate = self


        let apiConfig = EtbApiConfig(apiKey: "SMXSJLLNOJida")
        api = EtbApi(config: apiConfig)
        api.delegate = self
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
        
        let camera = GMSCameraPosition.cameraWithLatitude(coord.latitude, longitude: coord.longitude, zoom: 12)
        mapContainer.camera = camera;
        
        request.lat = coord.latitude
        request.lon = coord.longitude
        
        self.mapContainer.clear()
        
        api.search(request,offset: 0,limit: 15)
    }

    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        
        let accomodation = marker.userData as! Accommodation
        
        let frame = CGRectMake(16, 300, 200, 200)
        
        let accomodationView = HotelDetailsView.initWith(frame, accomodation: accomodation)
        self.view.addSubview(accomodationView)
        
        return true
    }
}

