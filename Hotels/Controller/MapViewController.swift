//
//  MapViewController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 6/11/15.
//  Copyright (c) 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, EtbApiDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mapContainer: GMSMapView!
    var resultSearchController: UISearchController!
    @IBOutlet weak var autocompleteResults: UITableView!
    @IBOutlet weak var autocompleteContainer: UIView!
    
    var data = [GMSAutocompletePrediction]()
    var request: SearchRequest!
    var placesClient: GMSPlacesClient?
    var api: EtbApi!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        placesClient = GMSPlacesClient()

        request = SearchRequest()
        request.lat = -33.86
        request.lon = 151.20
        request.type = "spr"
        
        var camera = GMSCameraPosition.cameraWithLatitude(request.lat, longitude: request.lon, zoom: 12)
        mapContainer.camera = camera;
        mapContainer.myLocationEnabled = true

       
        autocompleteResults.hidden = true
        autocompleteResults.delegate = self
        autocompleteResults.dataSource = self
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false

            controller.searchBar.searchBarStyle = .Minimal
            
            self.autocompleteContainer.backgroundColor = UIColor.clearColor()
            self.autocompleteContainer.addSubview(controller.searchBar);
            controller.searchBar.sizeToFit()

            return controller
        })()



        let apiConfig = EtbApiConfig(apiKey: "SMXSJLLNOJida")
        api = EtbApi(config: apiConfig)
        api.delegate = self
    }
    
   
    override func viewDidAppear(animated: Bool) {
        api.search(request,offset: 0,limit: 15)
    }

    func searchSuccessResult(result:AccomodationsResults) {
        
        
        for accomodation in result.accommodations {
            var marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(accomodation.location.lat, accomodation.location.lon)
            marker.title = accomodation.name
            marker.snippet = accomodation.summary.address
            marker.map = self.mapContainer
        }

    }

    func searchErrorResult(result:AnyObject) {

    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let sydney = CLLocationCoordinate2DMake(-33.8650, 151.2094)
        let northEast = CLLocationCoordinate2DMake(sydney.latitude + 1, sydney.longitude + 1)
        let southWest = CLLocationCoordinate2DMake(sydney.latitude - 1, sydney.longitude - 1)
        let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.Geocode
        
        let searchText = searchController.searchBar.text
        
        
        if count(searchText) > 0 {
            println("Searching for '\(searchText)'")
            self.autocompleteResults.hidden = false
            placesClient?.autocompleteQuery(searchText, bounds: bounds, filter: filter, callback: {
                (results, error) -> Void in
                if error != nil {
                    println("Autocomplete error \(error) for query '\(searchText)'")
                    return
                }

                println("Populating results for query '\(searchText)'")
                self.data = [GMSAutocompletePrediction]()
                if let unwrappedResults = results {
                    for result in unwrappedResults {
                        if let result = result as? GMSAutocompletePrediction {
                            self.data.append(result)
                        }
                    }
                }
                self.autocompleteResults.reloadData()
            })
        } else {
            self.data = [GMSAutocompletePrediction]()
            self.autocompleteResults.reloadData()
            self.autocompleteResults.hidden = true

        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.data.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.autocompleteResults.dequeueReusableCellWithIdentifier("AutocompleteTableViewCell") as! AutocompleteTableViewCell

        cell.locationTitle?.attributedText = self.data[indexPath.row].attributedFullText

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.autocompleteResults.deselectRowAtIndexPath(indexPath, animated: true)
        self.autocompleteResults.hidden = true
        let prediction = self.data[indexPath.row];
        placesClient?.lookUpPlaceID(prediction.placeID, callback: {
            (place, error) -> Void in
            if error != nil {
                println("Placelookup error \(error) for prediction '\(prediction.attributedFullText)'")
                return
            }
            if let place = place {
               self.showPlaceOnMap(place)
            }
        })
    }
    
    func showPlaceOnMap(place: GMSPlace)
    {
        let coord = place.coordinate;
        
        var camera = GMSCameraPosition.cameraWithLatitude(coord.latitude, longitude: coord.longitude, zoom: 12)
        mapContainer.camera = camera;
        
        request.lat = coord.latitude
        request.lon = coord.longitude
        
        api.search(request,offset: 0,limit: 15)
    }

}

