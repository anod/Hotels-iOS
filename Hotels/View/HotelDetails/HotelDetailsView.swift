//
//  HotelDetailsView.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/11/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class HotelDetailsView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var accomodation: Accommodation!

    init(frame: CGRect, accomodation: Accommodation) {
        super.init(frame: frame, style: UITableViewStyle.Plain)
        
        self.accomodation = accomodation
        self.delegate = self
        self.dataSource = self
        
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        

        self.tableHeaderView = setupToolbar()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 30))
        let pinButton = UIBarButtonItem(image: UIImage(named: "Pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "pinView:")
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        toolbar.setItems([space, pinButton], animated: false)
        return toolbar
    }
    
    func pinView(sender: UIBarButtonItem) {
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            return self.createTableCell(tableView, identifier: "HodelDetailsHeader")
        }
        
        //if indexPath.item == 1 {
            return self.createTableCell(tableView, identifier: "HotelDetailsFacilities")
        //}
        
    }

    func createTableCell(tableView: UITableView, identifier: String) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            self.registerNib(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier)
            let hdCell = cell as! HotelDetailsTableCell
            hdCell.attach(self.accomodation)
        }
        return cell
    }
}
