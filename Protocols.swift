//
//  Protocols.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/4/8.
//

import Foundation

public protocol Scaleable {
    /// 等比缩放指定
    /// - Parameter ratio: 指定比例
    func scale(with ratio: CGFloat) -> Self
}

