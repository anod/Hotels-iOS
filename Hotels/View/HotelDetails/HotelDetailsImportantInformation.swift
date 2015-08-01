//
//  HotelDetailsImportantInformation.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/1/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class HotelDetailsImportantInformation: UITableViewCell, HotelDetailsViewProtocol  {
    
    @IBOutlet weak var hotelImportantInformation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func attach(accomodation: Accommodation) {
        hotelImportantInformation.text = accomodation.details.importantInfo
    }
    
}
