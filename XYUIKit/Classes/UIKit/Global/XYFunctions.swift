//
//  XYFunctions.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/11/15.
//

import Foundation

/// 检查在同一个时间段内是否可以做某事
/// - Parameters:
///   - name: 事件名，标记用
///   - times: 可执行次数
///   - timeInterval: 时间间隔，用于在一段事件内实现对某件事的最大可执行次数
///   - sth: 具体要做的事情的回调
/// - Returns: 是否可以执行
public func doSth(withName name: String, maxTimes times: Int, timeInterval: TimeInterval, sth: (_ shouldDo: Bool, _ currentCount: Int)->()) {
    
    let SomeThingNameKey = name
    let SomeThingCountKey = name + "count"

    var shouldDo = true
    if let lastDateString = UserDefaults.standard.object(forKey: SomeThingNameKey) as? String,
       let lastDate = Date.date(withFormatter: "yyyyMMddHHmm", dateString: lastDateString){
        if Date().timeIntervalSince1970 > lastDate.timeIntervalSince1970 + timeInterval {
            // count 清空
            UserDefaults.standard.removeObject(forKey: SomeThingCountKey)
            
        }else{
            
            // count
            if let doneCount = UserDefaults.standard.object(forKey: SomeThingCountKey) as? Int,
            doneCount >= times {
                shouldDo = false
            }
        }
    }
    
    if shouldDo { // 计数
        UserDefaults.standard.setValue(Date().string(withFormatter:"yyyyMMddHHmm"), forKey: SomeThingNameKey)
        if let doneCount = UserDefaults.standard.object(forKey: SomeThingCountKey) as? Int {
            UserDefaults.standard.setValue( doneCount + 1, forKey: SomeThingCountKey)
        }else{
            UserDefaults.standard.setValue( 1, forKey: SomeThingCountKey)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    // 回调
    let doneCount = UserDefaults.standard.object(forKey: SomeThingCountKey) as? Int
    sth(shouldDo, doneCount ?? 0)
}

/// 在对象的生命周期内只执行一次事件
/// - Parameters:
///   - obj: 执行回调的对象，通常为 viewController 中
///   - function: 要执行的函数回调
///   - file: 当前文件，无需手动入参
///   - funName: 当前执行的所在的函数名，无需入参
///   - lineNum: 当前执行所在的行数，无需入参
public func doOnce(inObjLife obj: AnyObject, _ function: @escaping ()->(), file : String = #file , funName : String = #function , lineNum : Int = #line) {

    var key = file + funName + "\(lineNum)" + obj.debugDescription
    doOnce(for: key, callback: function)
}

fileprivate var onceTokens: [String] = []

/// 程序生命周期内只执行一次的代码
/// - Parameters:
///   - token: 指定 key, 每个 key 对应的事件只执行一次
///   - callback: 每个 key 对应的事件
public func doOnce(for token: String, callback: @escaping ()->()) {
    if onceTokens.contains(token) { return }
    onceTokens.append(token)
    callback()
}
