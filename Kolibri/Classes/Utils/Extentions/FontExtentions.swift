//
//  FontExtentions.swift
//  Kolibri
//
//  Created by Slav Sarafski on 26/5/17.
//  Copyright © 2017 Yanova. All rights reserved.
//

import UIKit

extension UIFont {
    static func normalFont(size:CGFloat) -> UIFont {
        if  let fontName = Bundle.font(name: "normal"),
            let font = UIFont(name: fontName, size: size) {
            return font
        }
        return UIFont.systemFont(ofSize:size)
    }
    
    static func boldFont(size:CGFloat) -> UIFont {
        if  let fontName = Bundle.font(name: "bold"),
            let font = UIFont(name: fontName, size: size) {
            return font
        }
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    static func italicFont(size:CGFloat) -> UIFont {
        if  let fontName = Bundle.font(name: "italic"),
            let font = UIFont(name: fontName, size: size) {
            return font
        }
        return UIFont.italicSystemFont(ofSize: size)
    }
}
