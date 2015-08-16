//
//  OrdersController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/11/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation
import CoreData

class OrdersController: UITableViewController {
    
    var orders: [AnyObject]!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let formatter = NSDateIntervalFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = NSDateIntervalFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateIntervalFormatterStyle.NoStyle
        
        let request = NSFetchRequest(entityName: "OrderSummary")
        
        do {
          orders = try managedObjectContext.executeFetchRequest(request)
        } catch let error as NSError {
            print("Failure to load context: \(error)")
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderCell")
        
        let data = orders[indexPath.row] as! NSManagedObject
        let orderId = data.valueForKey("orderId") as! Int
        cell?.textLabel?.text = "Order #\(orderId)"

        let checkIn = data.valueForKey("checkIn") as! NSDate
        let checkOut = data.valueForKey("checkOut") as! NSDate
        
        cell?.detailTextLabel!.text = formatter.stringFromDate(checkIn, toDate: checkOut)

        return cell!
    }
    
    
}