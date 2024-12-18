//
//  Runlooper.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/2/5.
//

/*
 * 模拟 Runloop 的逻辑,按指定时间循环执行事件
 */

import Foundation

@objc public class Runlooper: NSObject {
    private override init() {}
    static private var keys = [String]()
    static private var keyCountDict = [String: (Int, Int)]() // max current
    
    /// 开启一个事件循环, 按指定时间间隔执行回调
    /// - Note: 此函数调用之后不会停止, 需要谨慎使用
    /// - Parameters:
    ///   - interval: 时间间隔(单位:S)
    ///   - callback: 你要执行的事件
    @objc public static func startLoop(interval: TimeInterval, callback: @escaping ()->()){
        startLoop(forKey: "Runlooper_Default_Looper", interval: interval, callback: callback)
    }
    
    /// 开启一个指定 Key 事件循环
    /// - Note: 停止需要调用 ‘stopLoop(forKey: String)’ 函数
    /// - Parameters:
    ///   - forKey: 指定循环的 Key
    ///   - interval: 时间间隔(单位:S)
    ///   - callback: 你要执行的事件
    @objc public static func startLoop(forKey: String, interval: TimeInterval, callback: @escaping ()->()){
        if !keys.contains(forKey) { keys.append(forKey) }
        DispatchQueue.main.async { callback() }
        DispatchQueue.global().asyncAfter(deadline: .now() + interval, execute: {
            if keys.contains(forKey) {
                startLoop(forKey: forKey, interval: interval, callback: callback)
            }
        })
    }
    
    /// 开启一个指定 Key 事件循环 (指定循环次数, 到次数自动停止)
    /// - Note: 停止需要调用 ‘stopLoop(forKey: String)’ 函数
    /// - NOte: 此函数区别于不指定循环次数的函数, 不要用同样的 key 来同时调用两个函数
    /// - Parameters:
    ///   - forKey: 指定循环的 Key
    ///   - interval: 时间间隔(单位:S)
    ///   - loopCount: 指定循环次数, 次数到了自动停止
    ///   - callback: 你要执行的事件
    @objc public static func startLoop(forKey: String, interval: TimeInterval, loopCount: Int, callback: @escaping (_ currentCount: Int)->()){
        if !keys.contains(forKey) {
            keys.append(forKey)
            keyCountDict[forKey] = (loopCount, 0)
        }
        DispatchQueue.main.async {
            let counts = keyCountDict[forKey]
            let currentCount = counts?.1 ?? 0
            keyCountDict[forKey] = (loopCount, currentCount + 1)
            
            if currentCount < loopCount {
                callback(currentCount)
            } else {
                stopLoop(forKey: forKey)
            }
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + interval, execute: {
            if keys.contains(forKey) {
                startLoop(forKey: forKey, interval: interval, loopCount: loopCount, callback: callback)
            }
        })
    }
    
    /// 停止所有 looper
    /// - Note: 此方法会停止所有 looper, 谨慎使用
    @objc public static func stopLoop(){
        keys.removeAll()
    }
    
    /// 停止指定 Key 的 looper
    @objc public static func stopLoop(forKey: String){
        keys.removeAll { $0 == forKey }
    }
    
}
