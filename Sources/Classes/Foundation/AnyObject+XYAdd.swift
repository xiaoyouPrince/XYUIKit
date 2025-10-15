//
//  AnyObject+XYAdd.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2025/10/15.
//

import Foundation

public extension NSObject {
    
    /// 获取当前对象的内存地址 e.g. 0x000060000023f6c0
    var memoryAddress: String {
        "\(Unmanaged.passUnretained(self).toOpaque())"
    }
}


/// 获取指定对象的内存地址, e.g. 0x000060000023f6c0
/// - Parameter object: 对象
/// - Returns: String 形式的内存地址
public func getMemoryAddress(_ object: AnyObject) -> String {
    "\(Unmanaged.passUnretained(object).toOpaque())"
}
