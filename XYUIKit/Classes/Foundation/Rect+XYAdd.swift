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
}

extension CGRect: Scaleable {
    public func scale(with ratio: CGFloat) -> Self {
        .init(origin: origin, size: size.scale(with: ratio))
    }
}
