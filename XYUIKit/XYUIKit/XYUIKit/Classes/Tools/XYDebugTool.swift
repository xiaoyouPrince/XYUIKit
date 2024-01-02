//
//  XYDebugTool.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2024/1/2.
//
/*
 * - TODO -
 * 提供一些 debug 功能
 *
 */

import Foundation

@objc public class DebugTool: NSObject {
    
    /// 在某个日期之前有效
    /// - Parameter date: 指定日期
    @objc static public func doBefore(date: Date, callback: @escaping ()->()) {
        doInDebug {
            if date.timeIntervalSince1970 > Date().timeIntervalSince1970 {
                callback()
            }
        }
    }
    
    /// 在某个日期之前有效
    /// - Parameter dateFormatStr: 指定日期格式 "yyyy-MM-dd HH:mm:ss"
    /// - NOTE: 时间格式例如 ‘ 2023-12-15 下午2:22:28 ’， 必须手动写上/下午
    @objc static public func doBefore(dateFormatStr: String, callback: @escaping ()->()) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: dateFormatStr) ?? .init()
        doBefore(date: date, callback: callback)
    }
}

extension DebugTool {
    @objc static func doInDebug(callback: @escaping ()->()) {
#if DEBUG
        callback()
#else
        // do nothing
#endif
    }
    
    @objc func doInDebug(callback: @escaping ()->()) {
        DebugTool.doInDebug {
            callback()
        }
    }
}

extension DebugTool {
    
    /// 移除指定目录下的指定路径,
    /// - NOTE: 这是一个测试代码, 本代码移除指定路径下的 /testZip 路径, 比如 ~/testZip/a.png --> ~/a.png
    /// - Parameter forPath: 指定目录, 默认为项目的文档目录
    @objc static func rmTestZipPath(_ forPath: String? = XYFileManager.documentPath) {
        let fm = FileManager.default
        guard let basePath = forPath else { return }
        var contentsDir: [String]? = fm.subpaths(atPath: basePath)
        
        print("before rmTestZipPath")
        XYFileManager.showFileAndPath(basePath)
        print("--- end ---")
        
        if var contentsDir = contentsDir, contentsDir.isEmpty == false {
            contentsDir.reverse()
            contentsDir.forEach { atPath in
                let toPath = atPath.replacingOccurrences(of: "/testZip", with: "")
                do {
                    try fm.moveItem(atPath: basePath + "/" + atPath, toPath: basePath + "/" + toPath)
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
        
        print("afetr rmTestZipPath")
        XYFileManager.showFileAndPath(basePath)
        print("--- end ---")
    }
}
