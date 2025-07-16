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
        return .xy_getColor(red: 221, green: 221, blue: 221)
    }
    
    static var background: XYColor {
        return .xy_getColor(hex: 0xf0f0f0)
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
    
    @objc static func hexString(_ hexString: String, alpha: CGFloat = 1) -> UIColor {
        var str = ""
        if hexString.lowercased().hasPrefix("0x") {
            str = hexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.lowercased().hasPrefix("#") {
            str = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            str = hexString
        }
        
        let length = str.count
        // 如果不是 RGB RGBA RRGGBB RRGGBBAA 结构
        if length != 3 && length != 4 && length != 6 && length != 8 {
            return .clear
        }
        
        // 将 RGB RGBA 转换为 RRGGBB RRGGBBAA 结构
        if length < 5 {
            var tStr = ""
            str.forEach { tStr.append(String(repeating: $0, count: 2)) }
            str = tStr
        }
        
        guard let hexValue = Int(str, radix: 16) else { return .clear }
        
        var red = 0
        var green = 0
        var blue = 0
        
        if length == 3 || length == 6 {
            red = (hexValue >> 16) & 0xFF
            green = (hexValue >> 8) & 0xFF
            blue = hexValue & 0xFF
        } else {
            red = (hexValue >> 20) & 0xFF
            green = (hexValue >> 16) & 0xFF
            blue = (hexValue >> 8) & 0xFF
        }
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
    
    func getRGBA() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        guard let components = self.cgColor.components else {
            return (0, 0, 0, 1)
        }
        
        if self.cgColor.numberOfComponents == 2 {
            return (components[0], components[0], components[0], components[1])
        } else {
            return (components[0], components[1], components[2], components[3])
        }
    }
    
    /// 返回颜色的16进制汉字表示,  #FFFFFF
    @objc func toHexString() -> String {
        let rgb = getRGBA()
        let redInt = Int(rgb.red * 255 + 0.5)
        let greenInt = Int(rgb.green * 255 + 0.5)
        let blueInt = Int(rgb.blue * 255 + 0.5)
        
        return String(format: "#%02X%02X%02X", redInt, greenInt, blueInt)
    }
}

public extension XYColor {
    
    /// 快速创建一个 Hex 颜色
    /// - Parameter hex: hex 数值
    /// - Returns: XYColor
    @objc static func color(hex: Int) -> XYColor {
        return .xy_getColor(hex: hex)
    }
    
    /// 快速创建一个基于RGB整数值的颜色
    /// - Parameters:
    ///   - red: 红
    ///   - green: 绿
    ///   - blue: 蓝
    /// - Returns: XYColor
    @objc static func color(red: Int, green: Int, blue: Int) -> XYColor {
        return .xy_getColor(red: red, green: green, blue: blue)
    }
    
    /// 快速创建一个颜色, 区分亮暗两种模式
    /// - Parameter hex: hex 数值
    /// - Parameter hex_: 暗模式下的 hex 数值
    /// - Returns: XYColor
    @available(iOS 12.0, *)
    @objc static func color(light: XYColor, dark: XYColor) -> XYColor {
        if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
            return dark
        } else {
            return light
        }
    }
    
    /// 快速创建一个 Hex 颜色, 区分亮暗两种模式
    /// - Parameter hex: hex 数值
    /// - Parameter hex_: 暗模式下的 hex 数值
    /// - Returns: XYColor
    @available(iOS 12.0, *)
    @objc static func color(hex: Int, dark hex_: Int) -> XYColor {
        if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
            return .color(hex: hex_)
        } else {
            return .color(hex: hex)
        }
    }
    
    /// 快速创建一个基于RGB整数值的颜色, 区分亮暗两种模式
    /// - Parameters:
    ///   - red: 红
    ///   - green: 绿
    ///   - blue: 蓝
    ///   - red_: 暗模式下的 红 数值
    ///   - green_: 暗模式下的 绿 数值
    ///   - blue_: 暗模式下的 蓝 数值
    /// - Returns: XYColor
    @available(iOS 12.0, *)
    @objc static func color(red: Int, green: Int, blue: Int, darkR red_: Int, darkG green_: Int, darkB blue_: Int) -> XYColor {
        if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
            return .color(red: red_, green: green_, blue: blue_)
        } else {
            return .color(red: red, green: green, blue: blue)
        }
    }
}
