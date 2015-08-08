//
//  HotelDetailsCell.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/24/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

protocol HotelDetailsCellDelegate {
    func collectionViewCell(cell: HotelDetailsCell, willMoveToWindow newWindow: UIWindow?)
    func collectionViewCellWillPrepareForReuse(cell: HotelDetailsCell)
}

class HotelDetailsCell : UICollectionViewCell {
    var delegate: HotelDetailsCellDelegate!
    var contentViewController: UIViewController!
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        self.delegate.collectionViewCell(self, willMoveToWindow: newWindow)
    }
    
    override func prepareForReuse() {
        self.delegate.collectionViewCellWillPrepareForReuse(self)
        super.prepareForReuse()
    }
    
}
