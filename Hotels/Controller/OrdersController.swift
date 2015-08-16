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
        let orderId = data.valueForKey("orderId") as! Int
        cell?.textLabel?.text = "Order #\(orderId)"

        let checkIn = data.valueForKey("checkIn") as! NSDate
        let checkOut = data.valueForKey("checkOut") as! NSDate
        
        cell?.tag = orderId
        cell?.detailTextLabel!.text = formatter.stringFromDate(checkIn, toDate: checkOut)

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.addSubview(activityIndicator)
        
        let orderId = cell?.tag
        api.retrieve(orderId!)
    }
    
    func retrieveSuccessResult(result:OrderResult) {
        activityIndicator.removeFromSuperview()
        
        let vc : ConfirmationController = ControllerUtils.instantiate("ConfirmationController")
        vc.result = result
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func retrieveErrorResult(error:NSError) {
        activityIndicator.removeFromSuperview()
        
        ErrorAlertView.show("\(error.localizedDescription)", controller: self)
        print(error)
    }
}