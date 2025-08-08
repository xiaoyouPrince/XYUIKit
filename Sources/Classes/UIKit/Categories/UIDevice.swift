//
//  UIDevice.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2025/6/16.
//

import Foundation
import UIKit

public extension UIDevice {
    
    /// 是否是横屏
    /// - 注意此属性仅判断当前设备朝向是横屏, 如果平放状态可能会不准
    var isLandscape: Bool {
        let orientation = UIDevice.current.orientation
        return orientation == .landscapeLeft || orientation == .landscapeRight
    }
    
    /// 是否是竖屏
    /// - 注意此属性仅判断当前设备朝向是竖屏, 如果平放状态可能会不准 
    var isPortrait: Bool {
        let orientation = UIDevice.current.orientation
        return orientation == .portrait || orientation == .portraitUpsideDown
    }
    
    /// 是否是有效的方向（非平放状态）
    var isValidInterfaceOrientation: Bool {
        return isLandscape || isPortrait
    }
}
