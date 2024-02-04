//
//  Bool+XYAdd.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2023/8/29.
//

import Foundation

extension Bool {
    /// 返回 bool 值的 String 形式, egg: true -> "true" / false -> "false"
    public var stringValue: String {
        self ? "true" : "false"
    }
    
    /// 返回 bool 值的 String 形式, egg: true -> 1 / false -> 0
    public var intValue: Int {
        self ? 1 : 0
    }
}
