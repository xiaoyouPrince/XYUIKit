//
//  Rect+XYAdd.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/1/22.
//

import Foundation

public extension CGRect {
    
    /// 交换宽高
    /// - Returns: 返回一个交换宽高的 rect
    func swapRectWH() -> CGRect {
        return .init(x: origin.x, y: origin.y, width: size.height, height: size.width)
    }
    
    /// 等比缩放, 原点不变, 尺寸等比缩放
    /// - Parameter ratio: 缩放比例
    /// - Returns: 缩放后的 rect
    func scale(with ratio: CGFloat) -> Self {
        .init(origin: origin, size: size.scale(with: ratio))
    }
}

public extension CGSize {
    /// 尺寸宽高按比例缩放
    /// - Parameter ratio: 缩放比例
    /// - Returns: 缩放后的size
    func scale(with ratio: CGFloat) -> Self {
        .init(width: width * ratio, height: height * ratio)
    }
}
