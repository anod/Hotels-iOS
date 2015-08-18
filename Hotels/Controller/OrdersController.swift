//
//  OrdersController.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/11/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation
import CoreData

class OrdersController: UITableViewController, EtbApiDelegate {
    
    var orders: [AnyObject]!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let formatter = NSDateIntervalFormatter()
    
    var activityIndicator: UIActivityIndicatorView!
    
    let api = ApiUtils.create()
    
    var orderIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api.delegate = self
        
        formatter.dateStyle = NSDateIntervalFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateIntervalFormatterStyle.NoStyle
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
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
        let confirmationId = data.valueForKey("confirmationId") as! String

        cell?.textLabel?.text = "Order #\(confirmationId)"

        let checkIn = data.valueForKey("checkIn") as! NSDate
        let checkOut = data.valueForKey("checkOut") as! NSDate
        let datesText = formatter.stringFromDate(checkIn, toDate: checkOut)
        
        let hotelName = data.valueForKey("hotelName") as! String

        cell?.tag = indexPath.row
        cell?.detailTextLabel!.text = "\(datesText) - \(hotelName)"

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.addSubview(activityIndicator)
        
        self.orderIndex = (cell?.tag)!
        let data = orders[self.orderIndex] as! NSManagedObject
        let orderId = data.valueForKey("orderId") as! Int
        api.retrieve(orderId)
    }
    
    func retrieveSuccessResult(result:OrderResult) {
        activityIndicator.removeFromSuperview()
        
        let vc : ConfirmationController = ControllerUtils.instantiate("ConfirmationController")
        vc.result = result
        let orderRate = result.order!.rates[0]
        
        // Fix currency
        let data = orders[self.orderIndex] as! NSManagedObject
        let currency = data.valueForKey("currency") as! String
        let postpaidCurrency = data.valueForKey("postpaidCurrency") as! String
        
        let isPostpaid = data.valueForKey("isPostpaid") as! Bool
        if isPostpaid {
            orderRate.request.currency = postpaidCurrency
            orderRate.accommodation.postpaidCurrency = postpaidCurrency
        } else {
            orderRate.request.currency = currency
            orderRate.accommodation.postpaidCurrency = postpaidCurrency
        }
        
        vc.accommodation = orderRate.accommodation
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func retrieveErrorResult(error:NSError) {
        activityIndicator.removeFromSuperview()
        
        ErrorAlertView.show("\(error.localizedDescription)", controller: self)
        print(error)
    }
}