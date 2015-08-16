//
//  Order+CoreDataProperties.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/14/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension OrderSummary {

    @NSManaged var orderId: NSNumber?
    @NSManaged var checkIn: NSDate?
    @NSManaged var checkOut: NSDate?
    @NSManaged var hotelName: String?
    @NSManaged var hotelAddress: String?
    @NSManaged var persons: NSNumber?

}
