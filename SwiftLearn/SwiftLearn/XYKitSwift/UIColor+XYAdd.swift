//
//  UIColor+XYAdd.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/4/25.
//

import UIKit

extension UIColor {
    
    @objc static public func xy_getColor(hex: Int) -> UIColor {
        let r = ((CGFloat)(hex >> 16 & 0xFF))
        let g = ((CGFloat)(hex >> 8 & 0xFF))
        let b = ((CGFloat)(hex & 0xFF))
        let color = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        return color
    }
    
    @objc static public func xy_getColor(red: Int, green: Int, blue: Int) -> UIColor {
        let r = (CGFloat)(red);
        let g = (CGFloat)(green);
        let b = (CGFloat)(blue);
        let color = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        return color
    }
}
