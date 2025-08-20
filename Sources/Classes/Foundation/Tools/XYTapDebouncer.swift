//
//  XYTapDebouncer.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2025/8/20.
//

import Foundation

public typealias TapDebouncer = XYTapDebouncer
public class XYTapDebouncer {
    // 默认实例
    public static let `default` = XYTapDebouncer(interval: 0.5)
    
    private var isTapInProgress: Bool = false
    private let interval: TimeInterval
    
    /// 自定义间隔时间初始化
    /// - Parameter interval: 指定防抖时间间隔
    public init(interval: TimeInterval) {
        self.interval = interval
    }
    
    /// 直接检查是否需要被拦截
    /// - Returns: true / false
    public func shouldPreventMultipleTaps() -> Bool {
        if isTapInProgress { return true }
        isTapInProgress = true
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.isTapInProgress = false
        }
        return false
    }
    
    /// 便捷的检查方法，带任务回调参数
    /// - Parameter task: true 可以执行, false 应该被拦截
    public func executeIfAllowed(_ task: @escaping (Bool) -> Void) {
        let isPrevented = shouldPreventMultipleTaps()
        task(!isPrevented)
    }
    
    /// 更简洁的便捷方法 - 不拦截时候执行回调
    /// - Parameter task: 仅在任务不需要被拦截时回调
    public func executeIfAllowed(_ task: @escaping () -> Void) {
        if !shouldPreventMultipleTaps() {
            task()
        }
    }
}

/* ************* 使用示例 *************
class ViewController: UIViewController {
    // 创建自定义间隔拦截实例
    let customDebouncer = TapDebouncer(interval: 1.0)
    
    @objc func buttonTapped() {
        // 使用默认实例
        TapDebouncer.default.executeIfAllowed { isIntercepted in
            if !isIntercepted {
                print("按钮点击被执行")
                self.performAction()
            } else {
                print("点击被拦截")
            }
        }
        
        // 或者更简洁的写法
        TapDebouncer.default.executeIfAllowed {
            print("按钮点击被执行")
            self.performAction()
        }
        
        // 使用自定义实例
        customDebouncer.executeIfAllowed {
            print("自定义间隔时间的操作")
        }
        
        // 原始用法,默认不用回调的形式
        if !TapDebouncer.default.shouldPreventMultipleTaps() {
            print("原始用法")
        }
    }
    
    private func performAction() {
        // 执行具体的业务逻辑
    }
}
*/
