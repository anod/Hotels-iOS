//
//  OrderSummary+CoreDataProperties.swift
//  
//
//  Created by Alex Gavrishev on 8/17/15.
//
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension OrderSummary {

    @NSManaged var checkIn: NSDate?
    @NSManaged var checkOut: NSDate?
    @NSManaged var hotelAddress: String?
    @NSManaged var hotelName: String?
    @NSManaged var orderId: NSNumber?
    @NSManaged var persons: NSNumber?
    @NSManaged var confirmationId: String?
    @NSManaged var password: String?

}
