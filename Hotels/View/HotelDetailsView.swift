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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "HodelDetailsHeader"
        var headerCell: HodelDetailsHeader! = tableView.dequeueReusableCellWithIdentifier(identifier) as? HodelDetailsHeader
        if headerCell == nil {
            self.registerNib(UINib(nibName: "HodelDetailsHeader", bundle: nil), forCellReuseIdentifier: identifier)
            headerCell = tableView.dequeueReusableCellWithIdentifier(identifier) as? HodelDetailsHeader
            headerCell.attach(self.accomodation)
        }
        
        return headerCell
    }

}
