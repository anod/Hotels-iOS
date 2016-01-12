//
//  PhotoBrowser.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/17/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation
import IDMPhotoBrowser

class PhotoBrowser: IDMPhotoBrowser {
    
    init(photos photosUrls: [String]!, caption: String, animatedFromView view: UIView!) {
        var photosWithURL = [IDMPhoto]()
        for imageStrUrl in photosUrls {
            let photo = IDMPhoto(URL: NSURL(string: imageStrUrl)!)
            photo.caption = caption
            photosWithURL.append(photo)
        }
        
        super.init(photos: photosWithURL, animatedFromView: view)
        
        self.displayCounterLabel = true
        self.displayActionButton = false

        
  
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: NSBundle(forClass: PhotoBrowser.self))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}