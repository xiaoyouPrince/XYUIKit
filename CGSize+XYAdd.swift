//
//  CGSize+XYAdd.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/4/8.
//

import Foundation

extension CGSize: Scaleable {
    public func scale(with ratio: CGFloat) -> Self {
        .init(width: width * ratio, height: height * ratio)
    }
}
