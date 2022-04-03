//
//  Date+XYAdd.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/5/30.
//
//  关于时间工具的一组拓展

import Foundation

extension Date {
    
    // MARK: - 获取 Date 的 世纪、年、月、日、时、分、秒、周、周汉字版、周英文版、是当年第几周、是当月第几周、是否闰年
    /// 获取当前 Date 内容
    /// - Parameter com: 日历组件
    /// - Returns: the result
    func current(component com: Calendar.Component) -> Int {
        let calender = Calendar.current
        return calender.component(com, from: self)
    }
    
    // MARK: - 时间比较
    
    /// 比较两个 date 是否是同一天
    /// - Parameters:
    ///   - date0: date0
    ///   - date1: date1
    /// - Returns: true / false
    public static func isSameDay(_ date0: Date, otherDate date1: Date) -> Bool {
        return date0.current(component: .year) == date1.current(component: .year) &&
        date0.current(component: .month) == date1.current(component: .month) &&
        date0.current(component: .day) == date1.current(component: .day)
    }
    
    // MARK: - 便利构造方法，字符串创建时间，Date 创建字符串
    static func date(withFormatter fmt: String, dateString dateStr: String) -> Date? {
        let fmt_ = DateFormatter()
        fmt_.dateFormat = fmt
        return fmt_.date(from: dateStr)
    }
    
    func string(withFormatter fmt:String) -> String {
        let fmt_ = DateFormatter()
        fmt_.dateFormat = fmt
        return fmt_.string(from: self)
    }
}


public func currentVisibleController() -> UIViewController {
    
    var keyWindow: UIWindow? = nil
    for window in UIApplication.shared.windows {
        if window.isKeyWindow {
            keyWindow = window
            break
        }
    }
    
    var topController = keyWindow!.rootViewController!
    
    if let tabBarVC = topController as? UITabBarController {
        topController = tabBarVC.selectedViewController ?? topController
        
        if let nav = topController as? UINavigationController {
            topController = nav.visibleViewController ?? topController
            
            while topController.presentedViewController != nil {
                topController = topController.presentedViewController!
            }
        }
        return topController
    }
    
    if let nav = topController as? UINavigationController {
        topController = nav.visibleViewController ?? topController
        while topController.presentedViewController != nil {
            topController = topController.presentedViewController!
        }
    }
    return topController
}
