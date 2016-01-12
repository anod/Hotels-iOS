//
//  UILabel.swift
//  Hotels
//
//  Created by Alex Gavrishev on 8/8/15.
//  Copyright © 2015 Alex Gavrishev. All rights reserved.
//

import UIKit

extension UILabel {

    func setHtml(html: String) {
        do {
            // Changing the font in your HTML response string before it gets parsed.
            let text = try NSMutableAttributedString(
                    data: html.dataUsingEncoding(NSUnicodeStringEncoding)!,
                    options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                    documentAttributes: nil)
            
            let font = FontUtils.regularWithSize(16)
            text.addAttributes([NSFontAttributeName: font], range: NSMakeRange(0, text.length))
            
            self.attributedText = text
        } catch let error as NSError {
            print("setHtml: \(error.domain)")
        }
    }
}
