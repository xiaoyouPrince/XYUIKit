//
//  Console.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/6/8.
//

import Foundation

/// 控制台打印输出
public struct Console {
    
    /// log
    /// - Parameters:
    ///   - item: 要打印的对象,可以为一个,也可为一串
    ///   - filePath: 所在文件路径
    ///   - line: 所在行数
    public static func log(_ item: Any..., filePath: String = #file, line: Int = #line) {
        #if DEBUG
        print("\(Date())[\(fileName(filePath))](\(line)):", item)
        #endif
    }
    
    /// debugLog
    /// - Parameters:
    ///   - item: 要打印的对象,可以为一个,也可为一串
    ///   - filePath: 所在文件路径
    ///   - line: 所在行数
    public static func debugLog(_ item: Any..., filePath: String = #file, line: Int = #line) {
        #if DEBUG
        debugPrint("\(Date())[\(fileName(filePath))](\(line)):", item)
        #endif
    }
    
    /// log
    /// - Parameters:
    ///   - item: 要打印的对象,如果为 字典,数组,则会序列化输出
    ///   - filePath: 所在文件路径
    ///   - line: 所在行数
    public static func log(_ item: @autoclosure() -> Any, filePath: String = #file, line: Int = #line) {
        #if DEBUG
        let fileName = fileName(filePath)
        do {
            if JSONSerialization.isValidJSONObject(item()) {
                let data = try JSONSerialization.data(withJSONObject: item(), options: .prettyPrinted)
                let json = String(data: data, encoding: .utf8) ?? "json serialization print error"
                print("\(Date())[\(fileName)](\(line)):", json)
            } else {
                print("\(Date())[\(fileName)](\(line)):", item())
            }
        } catch {
            print("\(Date())[\(fileName)](\(line)):", item())
        }
        #endif
    }
    
    private init() {}
}

extension Console {
    
    static private func fileName(_ filePath: String) -> String {
        URL(fileURLWithPath: filePath).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
    }
}
