//
// Created by Alex Gavrishev on 7/10/15.
// Copyright (c) 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

protocol AutocompleteDelegate: NSObjectProtocol {
    func onPlaceSelected(place:GooglePlaceDetails)
}

@objc
class AutocompleteViewController: NSObject, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, GooglePlacesDelegate {
    weak var autocompleteResults: UITableView!

    var data = [GoogleAutocompletePrediction]()

    var resultSearchController: UISearchController!
    var googlePlacesApi: GooglePlacesApi!
    var searchBar: UISearchBar!

    weak var delegate: AutocompleteDelegate?

    
    init(autocompleteResults: UITableView, toolbar: UIToolbar) {
        super.init()
        self.autocompleteResults=autocompleteResults

        autocompleteResults.hidden = true
        autocompleteResults.delegate = self
        autocompleteResults.dataSource = self

        self.searchBar = UISearchBar(frame: CGRectMake(0,0,240, 48))
        searchBar.placeholder = "Find a destination...."
        searchBar.searchBarStyle = .Minimal
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.tintColor = UIColor.whiteColor()
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as! UITextField
        textFieldInsideSearchBar.textColor = UIColor.whiteColor()

        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar.valueForKey("placeholderLabel") as! UILabel
        textFieldInsideSearchBarLabel.textColor = UIColor.whiteColor()
        
        searchBar.setImage(UIImage(named: "Search"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        searchBar.setImage(UIImage(named: "Cancel"), forSearchBarIcon: UISearchBarIcon.Clear, state: UIControlState.Normal)
        
        let item = UIBarButtonItem(customView: searchBar)
        toolbar.items?.insert(item, atIndex: 0)

        googlePlacesApi = GooglePlacesApi()
        googlePlacesApi.delegate = self
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            print("Searching for '\(searchText)'")
            self.googlePlacesApi.autocomplete(searchText)
            
            
            //            placesClient.autocompleteQuery(searchText, bounds: bounds, filter: filter, callback: {
            //                (results, error) -> Void in
            //                if error != nil {
            //                    print("Autocomplete error \(error) for query '\(searchText)'")
            //                    return
            //                }
            //
            //                print("Populating results for query '\(searchText)'")
            //                self.data = [GMSAutocompletePrediction]()
            //                if let unwrappedResults = results {
            //                    for result in unwrappedResults {
            //                        if let result = result as? GMSAutocompletePrediction {
            //                            self.data.append(result)
            //                        }
            //                    }
            //                }
            //                self.autocompleteResults.reloadData()
            //            })
        } else {
            self.data = [GoogleAutocompletePrediction]()
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

        cell.locationTitle?.text = self.data[indexPath.row].desc

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.autocompleteResults.deselectRowAtIndexPath(indexPath, animated: true)
        self.autocompleteResults.hidden = true
        let prediction = self.data[indexPath.row];
        
        self.googlePlacesApi.details(prediction);
        
    }
    
    func googlePlacesErrorResult(searchText: String, error: NSError) {
        print("Autocomplete error \(error) for query '\(searchText)'")
        
    }
    func googlePlacesPredictions(results: [GoogleAutocompletePrediction]) {
        self.data = results
        self.autocompleteResults.hidden = false
        self.autocompleteResults.reloadData()
    }
    
    func googlePlacesDetailsResult(result: GooglePlaceDetails) {
        self.delegate!.onPlaceSelected(result)
    }
    

    
}
