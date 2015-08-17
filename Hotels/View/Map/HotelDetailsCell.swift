//
//  HotelDetailsCell.swift
//  Hotels
//
//  Created by Alex Gavrishev on 7/24/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

protocol HotelDetailsCellDelegate : NSObjectProtocol {
    func collectionViewCell(cell: HotelDetailsCell, willMoveToWindow newWindow: UIWindow?)
    func collectionViewCellWillPrepareForReuse(cell: HotelDetailsCell)
}

class HotelDetailsCell : UICollectionViewCell {
    weak var delegate: HotelDetailsCellDelegate?
    weak var contentViewController: UIViewController?
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        print("willMoveToWindow")
        super.willMoveToWindow(newWindow)
        self.delegate!.collectionViewCell(self, willMoveToWindow: newWindow)
    }
    
    override func prepareForReuse() {
        print("prepareForReuse")
        self.contentViewController = nil
        self.delegate!.collectionViewCellWillPrepareForReuse(self)
        super.prepareForReuse()
    }
    
}
