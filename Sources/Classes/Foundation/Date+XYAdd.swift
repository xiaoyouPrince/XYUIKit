//
//  Date+XYAdd.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/5/30.
//
//  关于时间工具的一组拓展

import Foundation

public extension Date {
    
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
    static func isSameDay(_ date0: Date, otherDate date1: Date) -> Bool {
        return date0.current(component: .year) == date1.current(component: .year) &&
        date0.current(component: .month) == date1.current(component: .month) &&
        date0.current(component: .day) == date1.current(component: .day)
    }
    
    // MARK: - 便利构造方法，字符串创建时间，Date 创建字符串
    /// 给定格式和时间字符串构造时间
    /// - Parameters:
    ///   - fmt: 格式
    ///   - dateStr: 时间字符串
    /// - Returns: Date 对象
    static func date(withFormatter fmt: String, dateString dateStr: String) -> Date? {
        let fmt_ = DateFormatter()
        fmt_.dateFormat = fmt
        return fmt_.date(from: dateStr)
    }
    
    /// 返回指定格式的时间字符串
    /// - Parameter fmt: 格式
    /// - Returns: 时间字符串
    func string(withFormatter fmt:String) -> String {
        let fmt_ = DateFormatter()
        fmt_.dateFormat = fmt
        return fmt_.string(from: self)
    }
    
    /// 计算该 date 距离指定 date 之间剩余的时间, 自己指定时间类型, 仅支持 ‘年月日时分秒’, 其余返回 0
    /// - Parameter date: 指定的 date
    /// - Parameter component: 指定计算类型 如小时/分钟/秒
    /// - Returns: 距离指定 Dete 之间剩余的时间结果
    func timeBetweenToDate(_ date: Date, component: Calendar.Component) -> Int {
        let timeInterval = date.timeIntervalSince1970 - self.timeIntervalSince1970
        if component == .year {
            return Int(timeInterval / (365 * 24 * 3600)) // 假设每年365天 -
        }
        if component == .month {
            return Int(timeInterval / (30 * 24 * 3600)) // 假设每月30天
        }
        if component == .day {
            return Int(timeInterval / (24 * 3600))
        }
        if component == .hour {
            return Int(timeInterval / (3600))
        }
        if component == .minute {
            return Int(timeInterval / (60))
        }
        if component == .year {
            return Int(timeInterval)
        }
        return 0
    }
    
    /// 计算该 Date 距离今天剩余时间
    /// - Parameter component: 指定计算类型 如小时/分钟/秒
    /// - Returns: 距离今天结束剩余的时间, 注意,需要指定的时间范围为今天
    func timeRemainingInDay(component: Calendar.Component) -> Int? {
        let calendar = Calendar.current
        // 获取当前日期的年、月、日
        let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        // 获取给定日期的年、月、日
        let targetDateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        // 如果给定日期的年、月、日不是当前日期，直接返回 nil，表示无法计算
        guard currentDateComponents == targetDateComponents else {
            return nil
        }
        
        // 获取今天结束的时间
        if let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) {
            // 计算给定时间距离今天结束的差异
            let components = calendar.dateComponents([component], from: self, to: endOfDay)
            if let timeRemaining = components.value(for: component) {
                return timeRemaining
            }
        }
        
        return nil
    }
    
    /// 计算当前日期距离今天结束还有几个小时
    /// - Returns: 剩余小时数. 注意: 当前日期需要为今天的日期
    func hoursRemainingInDay() -> Int? {
        timeRemainingInDay(component: .hour)
    }
    
    /// 计算当前日期距离今天结束还有多少分钟
    /// - Returns: 剩余分钟数. 注意: 当前日期需要为今天的日期
    func minutesRemainingInDay() -> Int? {
        timeRemainingInDay(component: .minute)
    }
    
    /// 计算该 Date 距离今年结束剩余的天数
    /// - Returns: 剩余天数, 注意: 当前日期需要时今年的日期
    func daysRemainingInYear() -> Int? {
        let calendar = Calendar.current
        
        // 获取当前日期的年份
        let currentYear = calendar.component(.year, from: Date())
        // 获取给定日期的年份
        let targetYear = calendar.component(.year, from: self)
        // 如果给定日期的年份不是当前年份，直接返回 nil，表示无法计算
        guard currentYear == targetYear else {
            return nil
        }
        
        // 获取当前日期的最后一天
        if let lastDayOfYear = calendar.date(from: DateComponents(year: currentYear, month: 12, day: 31)) {
            // 计算给定日期距离今年结束的天数
            let components = calendar.dateComponents([.day], from: self, to: lastDayOfYear)
            if let daysRemaining = components.day {
                return daysRemaining
            }
        }
        
        return nil
    }
    
    /// 计算该 Date 距离本月结束剩余的天数
    /// - Returns: 剩余天数, 注意: 当前日期需要时今年的日期
    func daysRemainingInMonth() -> Int? {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)
        
        // 获取本月总天数
        guard let totalDaysInMonth = range?.count else {
            return nil
        }
        
        // 获取当前日期的日
        let components = calendar.dateComponents([.day], from: self)
        guard let currentDay = components.day else {
            return nil
        }
        
        // 计算距离本月结束的天数
        let daysRemainingInMonth = totalDaysInMonth - currentDay
        return daysRemainingInMonth
    }

    /// 计算该 Date 距离本周结束剩余的天数
    /// - Returns: 剩余天数, 注意: 当前日期需要时今年的日期
    func daysRemainingInWeek() -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)
        
        // 获取当前日期是星期几
        guard let currentWeekday = components.weekday else {
            return nil
        }
        
        // 计算距离本周结束的天数
        let daysRemainingInWeek = 8 - currentWeekday
        return daysRemainingInWeek
    }

    /// 计算距离下次生日剩余天数
    /// - Parameter birthday: 指定生日的 date
    /// - Returns: 距离下次过生日剩余的天数
    func daysUntilBirthday(birthday: Date) -> Int {
        let calendar = Calendar.current
        // 获取当前日期
        let currentDate = Date()
        var nextBirthday = birthday + 86400// 以当天24:00 为截止
        
        
        // 如果今年的生日已经过去，就计算下一年的生日
        while currentDate > nextBirthday {
            nextBirthday = calendar.date(byAdding: .year, value: 1, to: nextBirthday)!
        }
        
        // 计算距离生日的天数
        let components = calendar.dateComponents([.day], from: currentDate, to: nextBirthday)
        if let daysUntilBirthday = components.day {
            return daysUntilBirthday
        }
        
        return 0
    }

}

public extension Date {
    
    /// 获取用户设置的时间格式是否是 24 小时制
    static var is24HourFormat: Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none // 设置日期格式为时间样式
        dateFormatter.timeStyle = .short // 设置为短时间格式
        
        // 获取当前设备时间格式
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)
        
        // ah时 -- 为 12 小时制
        // H 时 -- 为 24 小时制
        return dateFormat!.contains("H")
    }
}
