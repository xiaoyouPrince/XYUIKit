//
//  CGSize+XYAdd.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/7/9.
//

import Foundation

public extension CGSize {
    
    /// 屏幕尺寸
    static var screen: CGSize {
        .init(width: .width, height: .height)
    }
    
    /// 尺寸宽高按比例缩放
    /// - Parameter ratio: 缩放比例
    /// - Returns: 缩放后的size
    func scale(with ratio: CGFloat) -> Self {
        .init(width: width * ratio, height: height * ratio)
    }
}

