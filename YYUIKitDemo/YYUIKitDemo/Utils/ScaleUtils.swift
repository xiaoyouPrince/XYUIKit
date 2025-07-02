//
//  ScaleUtils.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2025/7/1.
//

import Foundation
import UIKit


let isPad = UIDevice.current.userInterfaceIdiom == .pad

extension Double {
    var px: Double {
        get {
            self * (UIScreen.main.bounds.size.width / 375.0)
        }
    }
    
    /// only used for ipad
    var pad: Double {
        self * iPadScrrenFitScale
    }
    
    /// only used for iphone
    var phone: Double {
        self * UIScreen.main.bounds.size.width / 375.0
    }
    
    var scale: Double {
        isPad ? self.pad : self.phone
    }
}

extension CGFloat {

    /// only used for ipad
    var pad: Double {
        self * iPadScrrenFitScale
    }
    
    /// only used for iphone
    var phone: Double {
        self * UIScreen.main.bounds.size.width / 375.0
    }
    
    var scale: Double {
        isPad ? self.pad : self.phone
    }
    
    /// 内部自行判断是否为 iPad 还是 iPhone，然后返回值的计算结果
    /// - Parameters:
    ///   - phone: iPhone 端的尺寸
    ///   - pad: iPad 端的尺寸
    /// - Returns: 经过比例计算的值
    static func supportPadSize(phone: Int, pad: Int) -> CGFloat {
        isPad ? pad.pad : phone.phone
    }
    
    /// 内部自行判断是否为 iPad 还是 iPhone，然后返回值的计算结果
    /// - Parameters:
    ///   - phone: iPhone 端的尺寸
    ///   - pad: iPad 端的尺寸
    /// - Returns: 经过比例计算的值
    static func supportPadSize(phone: Int, pad: Double) -> CGFloat {
        isPad ? pad.pad : phone.phone
    }
    
    /// 内部自行判断是否为 iPad 还是 iPhone，然后返回值的计算结果
    /// - Parameters:
    ///   - phone: iPhone 端的尺寸
    ///   - pad: iPad 端的尺寸
    /// - Returns: 经过比例计算的值
    static func supportPadSize(phone: Double, pad: Int) -> CGFloat {
        isPad ? pad.pad : phone.phone
    }
    
    /// 内部自行判断是否为 iPad 还是 iPhone，然后返回值的计算结果
    /// - Parameters:
    ///   - phone: iPhone 端的尺寸
    ///   - pad: iPad 端的尺寸
    /// - Returns: 经过比例计算的值
    static func supportPadSize(phone: Double, pad: Double) -> CGFloat {
        isPad ? pad.pad : phone.phone
    }
}

extension Int {
    var px: Double {
        get {
            UIDevice.current.userInterfaceIdiom == .pad ? Double(self) * (UIScreen.main.bounds.size.width / 1024.0) : Double(self) * (UIScreen.main.bounds.size.width / 375.0)
        }
    }
    
    /// only used for ipad
    var pad: Double {
        Double(self) * iPadScrrenFitScale
    }
    
    var phone: Double {
        Double(self) * UIScreen.main.bounds.size.width / 375.0
    }
    
    var scale: Double {
        isPad ? self.pad : self.phone
    }
}

// 提供一个只读属性来获取缓存值
var iPadScrrenFitScale: Double {
    return cachedIPadScreenFitScale
}

// 使用懒加载来存储缩放比例，这样只计算一次
private var cachedIPadScreenFitScale: Double = {
    var scale: Double = 1.0
    // iPad mini PPI is 326
    if isIpadMiniDevice() {
        scale = 0.9
    } else {
        // Other devices' PPI is 264
        let screenShortWidth = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        if screenShortWidth >= 1024 {
            scale = 1.0
        } else if screenShortWidth >= 800 {
            scale = 0.9
        } else {
            scale = 0.8
        }
    }
    return scale
}()


/// 判断当前设备是否是iPad mini。
func isIpadMiniDevice() -> Bool {
//    // iPad mini 设备标识符列表
//    let iPadMiniIdentifiers: Set<String> = [
//        "iPad2,5", "iPad2,6", "iPad2,7",         // iPad mini (1st generation)
//        "iPad4,4", "iPad4,5", "iPad4,6",         // iPad mini 2
//        "iPad4,7", "iPad4,8", "iPad4,9",         // iPad mini 3
//        "iPad5,1", "iPad5,2",                    // iPad mini 4
//        "iPad11,1", "iPad11,2",                  // iPad mini (5th generation)
//        "iPad14,1", "iPad14,2"                   // iPad mini (6th generation)
//    ]
//    // 获取设备标识符
//    var identifier = getDeviceIdentifier()
//    if identifier == "x86_64" || identifier == "arm64" {
//        identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? ""
//    }
//    return iPadMiniIdentifiers.contains(identifier)
    
    false
}
