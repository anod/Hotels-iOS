//
//  HotelDetailsCollectionView.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/17/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

@objc
protocol HotelDetailsCollectionViewControllerDataSource : NSObjectProtocol {
    func collectionView(view: UICollectionView, controllerForIdentifier identifier: String) -> UIViewController
}

class HotelDetailsCollectionView: UICollectionView, HotelDetailsCellDelegate {
    var backView: UIView!
    weak var controllerDataSource: HotelDetailsCollectionViewControllerDataSource!
    weak var containerViewController: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let index = self.indexPathForItemAtPoint(point)
        
        for view in self.subviews {
            if view.userInteractionEnabled && index != nil {
                return true
            }
        }
        return false
    }
    
    override func dequeueReusableCellWithReuseIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! HotelDetailsCell
        
        cell.delegate = self
        if cell.contentViewController == nil {
            cell.contentViewController = self.controllerDataSource.collectionView(self, controllerForIdentifier: identifier)
            
        }
        
        return cell
    }
    
    func didEndDisplayingCell(cell: UICollectionViewCell) {
        let cell = cell as! HotelDetailsCell
        let vc = cell.contentViewController
        self.unhostViewController(vc)
    }
    
    
    func unhostViewController(controller: UIViewController) {
        controller.willMoveToParentViewController(nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    
    func hostViewController(controller: UIViewController, withHostView superview: UIView) {
        self.containerViewController.addChildViewController(controller)
        controller.view.frame = superview.bounds
        controller.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        superview.addSubview(controller.view)
        controller.didMoveToParentViewController(self.containerViewController);
    }
    
    func collectionViewCell(cell: HotelDetailsCell, willMoveToWindow newWindow: UIWindow?) {
        self.hostViewController(cell.contentViewController, withHostView: cell.contentView)
    }
    
    func collectionViewCellWillPrepareForReuse(cell: HotelDetailsCell) {
        self.hostViewController(cell.contentViewController, withHostView: cell.contentView)
    }
}
