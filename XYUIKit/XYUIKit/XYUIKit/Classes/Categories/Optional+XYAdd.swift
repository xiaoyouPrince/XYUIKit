//
//  Optional+XYAdd.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2023/9/5.
//

import Foundation

extension Optional where Wrapped == String {
    public var `default`: String { self ?? "" }
}

extension Optional where Wrapped == Int {
    public var `default`: Int { self ?? 0 }
}

extension Optional where Wrapped == Bool {
    public var `default`: Bool { self ?? false }
}

extension Optional where Wrapped == Float {
    public var `default`: Float { self ?? 0 }
}

extension Optional where Wrapped == Double {
    public var `default`: Double { self ?? 0 }
}

extension Optional where Wrapped == CGFloat {
    public var `default`: CGFloat { self ?? 0 }
}

extension Optional where Wrapped: UIView {
    public var `default`: Wrapped { self ??  Wrapped.init() }
}








