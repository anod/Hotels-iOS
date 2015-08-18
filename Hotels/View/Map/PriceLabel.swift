//
//  PriceLabel.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/18/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import Foundation

class PriceLabel: ALabel {
    
    init() {
        super.init(frame: CGRectMake(0,0,50,21))
        self.font=FontUtils.regularWithSize(16)
        self.textAlignment=NSTextAlignment.Left;
        self.textColor=UIColor.whiteColor()
        self.userInteractionEnabled = true
        self.backgroundColor=UIColor.orangeColor()
        
        self.layer.cornerRadius = 8;
        self.clipsToBounds = true
        self.lineBreakMode = NSLineBreakMode.ByClipping
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}