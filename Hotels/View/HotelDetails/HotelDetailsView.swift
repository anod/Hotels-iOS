//
//  HotelDetailsView.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/11/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

protocol HotelDetailsViewDelegate {
    func onPinChange(pinned: Bool)
}

class HotelDetailsView: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, HotelDetailsViewProtocol {
    @IBOutlet weak var content: UITableView!
    
    var delegate: HotelDetailsViewDelegate!
    var pinned = false
    var accomodation: Accommodation!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setup() {
        self.userInteractionEnabled = true
        
        self.layer.cornerRadius = 10
        self.layer.shadowOffset = CGSizeMake(0, 2)
        self.layer.shadowRadius = 1.0
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).CGPath
        
        self.layer.masksToBounds = true
        
        self.content.delegate = self
        self.content.dataSource = self
        
        self.content.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    @IBAction func toolbarAction(sender: UIBarButtonItem) {
        print(sender)
    }
    
    func attach(accomodation: Accommodation) {
        self.accomodation = accomodation
        self.content.reloadData()
    }
    
       
    func pinView(sender: UIBarButtonItem) {
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            let cell = self.createTableCell(tableView, identifier: "HodelDetailsHeader")
            return cell
        }
        
        //if indexPath.item == 1 {
            return self.createTableCell(tableView, identifier: "HotelDetailsFacilities")
        //}
        
    }

    func createTableCell(tableView: UITableView, identifier: String) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            self.content.registerNib(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        }
        let hdCell = cell as! HotelDetailsViewProtocol
        hdCell.attach(self.accomodation)
        return cell
    }
}
