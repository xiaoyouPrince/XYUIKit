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
    var isLandscape: Bool {
        var isLandscape =  false
        let orientation = UIDevice.current.orientation
        if orientation == .landscapeLeft || orientation == .landscapeRight || orientation == .portrait || orientation == .portraitUpsideDown {
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                isLandscape = true
            } else {
                isLandscape = false
            }
        }
        return isLandscape
    }
    
    /// 是否是竖屏
    var isPortrait: Bool {
        var isPortrait =  false
        let orientation = UIDevice.current.orientation
        if orientation == .landscapeLeft || orientation == .landscapeRight || orientation == .portrait || orientation == .portraitUpsideDown {
            if orientation == .portrait || orientation == .portraitUpsideDown {
                isPortrait = true
            } else {
                isPortrait = false
            }
        }
        return isPortrait
    }
}
