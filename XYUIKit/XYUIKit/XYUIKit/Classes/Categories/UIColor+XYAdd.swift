//
//  UIColor+XYAdd.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/4/25.
//

#if os(iOS)
import UIKit
public typealias XYColor = UIColor
#endif
#if os(macOS)
import Cocoa
public typealias XYColor = NSColor
#endif

public func kHexColor(_ valueRGB: UInt) -> XYColor {
    return kHexColor(valueRGB, alpha: 1.0)
}

public func kHexColor(_ valueRGB: UInt, alpha: CGFloat) -> XYColor {
    return XYColor.init(
        red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat((valueRGB & 0x0000FF) >> 0) / 255.0,
        alpha: alpha)
}

public func randomColor() -> XYColor {
    return XYColor.randomColor()
}

public extension XYColor {
    
    static var random: XYColor {
        return randomColor()
    }
    
    static var line: XYColor {
        return .xy_getColor(red: 193, green: 193, blue: 193)
    }
    
    // MARK:-便利构造方法
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        // MARK:-必须通过self调用显式的构造方法
        self.init(red: r / 255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    // MARK: - 返回一个随机色
    class func randomColor() -> XYColor {
        return XYColor.init(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
    }
    
    @objc static func xy_getColor(hex: Int) -> XYColor {
        let r = ((CGFloat)(hex >> 16 & 0xFF))
        let g = ((CGFloat)(hex >> 8 & 0xFF))
        let b = ((CGFloat)(hex & 0xFF))
        let color = XYColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        return color
    }
    
    @objc static func xy_getColor(red: Int, green: Int, blue: Int) -> XYColor {
        let r = (CGFloat)(red);
        let g = (CGFloat)(green);
        let b = (CGFloat)(blue);
        let color = XYColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        return color
    }
}
