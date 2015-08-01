//
//  HotelDetailsFacilities.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/14/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

class HotelDetailsFacilities: UITableViewCell, UICollectionViewDataSource, HotelDetailsViewProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
    }
    
    func attach(accomodation: Accommodation) {
        let mainFacilities = accomodation.mainFacilities!

        if mainFacilities.contains(Facility.Internet.rawValue) {
            images.append("WiFi.png")
        }
        
        if mainFacilities.contains(Facility.AirConditioning.rawValue) {
            images.append("Winter.png")
        }
        
        if mainFacilities.contains(Facility.Parking.rawValue) {
            images.append("Parking.png")
        }
        
        if mainFacilities.contains(Facility.PetsAllowed.rawValue) {
            images.append("CatFootprint.png")
        }
        
        if mainFacilities.contains(Facility.NonSmoking.rawValue) {
            images.append("NoSmoking.png")
        }
        
        if mainFacilities.contains(Facility.Disabled.rawValue) {
            images.append("Wheelchair.png")
        }
        
        if mainFacilities.contains(Facility.FitnessCenter.rawValue) {
            images.append("Exercise.png")
        }
        
        if mainFacilities.contains(Facility.ChildDiscount.rawValue) {
            images.append("BabyBottle.png")
        }
        print(images)
        
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "FacilityView")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let image = UIImage(named: images[indexPath.row])
//        let icon = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        //let imageView = UIImageView(image: image)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FacilityCell", forIndexPath: indexPath)
        let imageView = cell.viewWithTag(100) as! UIImageView
        imageView.image = image
        
        //cell.frame = CGRectMake(0, 0, 50, 50)
        //cell.contentView.subviews.map { $0.removeFromSuperview() }
        //cell.contentView.addSubview(imageView)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

}


