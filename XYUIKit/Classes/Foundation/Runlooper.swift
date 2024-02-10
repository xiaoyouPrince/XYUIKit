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

@objc
public class Runlooper: NSObject{
    private override init() {}
    static private var keys = [String]()
    
    /// 开启一个事件循环, 按指定时间间隔执行回调
    /// - Note: 此函数调用之后不会停止, 需要谨慎使用
    /// - Parameters:
    ///   - interval: 时间间隔(单位:S)
    ///   - callback: 你要执行的事件
    @objc static func startLoop(interval: TimeInterval, callback: @escaping ()->()){
        startLoop(forKey: "Runlooper_Default_Looper", interval: interval, callback: callback)
    }
    
    /// 开启一个指定 Key 事件循环
    /// - Note: 停止需要调用 ‘stopLoop(forKey: String)’ 函数
    /// - Parameters:
    ///   - forKey: 指定循环的 Key
    ///   - interval: 时间间隔(单位:S)
    ///   - callback: 你要执行的事件
    @objc static func startLoop(forKey: String, interval: TimeInterval, callback: @escaping ()->()){
        if !keys.contains(forKey) { keys.append(forKey) }
        DispatchQueue.main.async { callback() }
        if keys.contains(forKey) {
            DispatchQueue.global().asyncAfter(deadline: .now() + interval, execute: {
                startLoop(forKey: forKey, interval: interval, callback: callback)
            })
        }
    }
    
    /// 停止所有 looper
    /// - Note: 此方法会停止所有 looper, 谨慎使用
    @objc static func stopLoop(){
        keys.removeAll()
    }
    
    /// 停止指定 Key 的 looper
    @objc static func stopLoop(forKey: String){
        keys.removeAll { $0 == forKey }
    }
    
}
