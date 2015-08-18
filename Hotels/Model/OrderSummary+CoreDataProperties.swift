//
//  OrderSummary+CoreDataProperties.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/18/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension OrderSummary {

    @NSManaged var checkIn: NSDate?
    @NSManaged var checkOut: NSDate?
    @NSManaged var confirmationId: String?
    @NSManaged var hotelAddress: String?
    @NSManaged var hotelName: String?
    @NSManaged var orderId: NSNumber?
    @NSManaged var password: String?
    @NSManaged var persons: NSNumber?
    @NSManaged var currency: String?
    @NSManaged var postpaidCurrency: String?
    @NSManaged var isPostpaid: NSNumber?

}
