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
            try self.attributedText = NSAttributedString(
                    data: html.dataUsingEncoding(NSUTF8StringEncoding)!,
                    options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                    documentAttributes: nil)
        } catch let error as NSError {
            print("setHtml: \(error.domain)")
        }
    }
}
