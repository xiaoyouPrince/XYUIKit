//
//  DispatchQueue+XYAdd.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/2/18.
//

import Foundation

// MARK: - DispatchQueue.once

public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    static func once(file: String = #file, function: String = #function, line: Int = #line, block: () -> Void) {
        let token = "\(file):\(function):\(line)"
        once(token: token, block: block)
    }
    
    static func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        guard !_onceTracker.contains(token) else { return }
        _onceTracker.append(token)
        block()
    }
}

// MARK: - DispatchQueue.safeMian
extension DispatchQueue {
    
    static var token: DispatchSpecificKey<()> = {
        let key = DispatchSpecificKey<()>()
        DispatchQueue.main.setSpecific(key: key, value: ())
        return key
    }()
    
    static var isMain: Bool {
        DispatchQueue.getSpecific(key: token) != nil
    }
    
    /// 主队列执行
    public static func safeMain(_ block: @escaping () ->()) {
        if DispatchQueue.isMain {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}

