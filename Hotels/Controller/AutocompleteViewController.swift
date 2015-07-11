//
// Created by Alex Gavrishev on 7/10/15.
// Copyright (c) 2015 Alex Gavrishev. All rights reserved.
//

import UIKit
import GoogleMaps

@objc
protocol AutocompleteDelegate {
    func onPlaceSelected(place:GMSPlace)
}

@objc
class AutocompleteViewController: NSObject, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {
    weak var autocompleteResults: UITableView!
    weak var autocompleteContainer: UIView!

    var data = [GMSAutocompletePrediction]()

    var resultSearchController: UISearchController!
    var delegate: AutocompleteDelegate!
    var placesClient: GMSPlacesClient?

    init(autocompleteResults: UITableView, autocompleteContainer: UIView) {
        super.init()
        self.autocompleteResults=autocompleteResults;
        self.autocompleteContainer=autocompleteContainer;

        // Do any additional setup after loading the view, typically from a nib.

        placesClient = GMSPlacesClient()

        autocompleteResults.hidden = true
        autocompleteResults.delegate = self
        autocompleteResults.dataSource = self

        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)

            controller.searchBar.placeholder = "Find a destination...."
            controller.searchBar.searchBarStyle = .Minimal
            controller.searchBar.showsCancelButton = false

            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false

            
            self.autocompleteContainer.backgroundColor = UIColor.clearColor()
            self.autocompleteContainer.addSubview(controller.searchBar);
            controller.searchBar.sizeToFit()

            return controller
        })()
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let sydney = CLLocationCoordinate2DMake(-33.8650, 151.2094)
        let northEast = CLLocationCoordinate2DMake(sydney.latitude + 1, sydney.longitude + 1)
        let southWest = CLLocationCoordinate2DMake(sydney.latitude - 1, sydney.longitude - 1)
        let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.Geocode

        let searchText = searchController.searchBar.text!


        if searchText.characters.count > 0 {
            print("Searching for '\(searchText)'")
            self.autocompleteResults.hidden = false
            placesClient?.autocompleteQuery(searchText, bounds: bounds, filter: filter, callback: {
                (results, error) -> Void in
                if error != nil {
                    print("Autocomplete error \(error) for query '\(searchText)'")
                    return
                }

                print("Populating results for query '\(searchText)'")
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
        let cell = self.autocompleteResults.dequeueReusableCellWithIdentifier("AutocompleteTableViewCell") as! AutocompleteTableViewCell

        cell.locationTitle?.attributedText = self.data[indexPath.row].attributedFullText

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.autocompleteResults.deselectRowAtIndexPath(indexPath, animated: true)
        self.autocompleteResults.hidden = true
        let prediction = self.data[indexPath.row];
        
        setSearchBoxText(prediction.attributedFullText.string)
        
        placesClient?.lookUpPlaceID(prediction.placeID, callback: {
            (place, error) -> Void in
            if error != nil {
                print("Placelookup error \(error) for prediction '\(prediction.attributedFullText)'")
                return
            }
            
            self.delegate.onPlaceSelected(place!)

        })
    }
    
    func setSearchBoxText(searchText: String) {
        self.resultSearchController.searchResultsUpdater = nil;
        self.resultSearchController.active = false
        self.resultSearchController.searchBar.text = searchText;
        self.resultSearchController.searchResultsUpdater = self; //or any delegate you like!
    }
    
}
