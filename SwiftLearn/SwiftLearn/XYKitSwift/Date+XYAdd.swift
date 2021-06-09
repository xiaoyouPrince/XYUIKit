//
//  Date+XYAdd.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/5/30.
//
//  关于时间工具的一组拓展

import Foundation

//@objc
//protocol Date_XYAdd_Method: NSObjectProtocol {
//
//    @objc optional
//    func currentDay() -> Int
//}

extension Date {
    
    // MARK: - 获取 Date 的 世纪、年、月、日、时、分、秒、周、周汉字版、周英文版、是当年第几周、是当月第几周、是否闰年
    
    func currentYear() -> Int{
        let calender = Calendar.current
        return calender.component(.year, from: self)
    }
    
    func currentMonth() -> Int{
        let calender = Calendar.current
        return calender.component(.month, from: self)
    }
    
    func currentDay() -> Int{
        let calender = Calendar.current
        return calender.component(.day, from: self)
    }
    
    func currentHour() -> Int{
        let calender = Calendar.current
        return calender.component(.hour, from: self)
    }
    
    func currentMinute() -> Int{
        let calender = Calendar.current
        return calender.component(.minute, from: self)
    }
    
    // MARK: - 时间比较
    
    
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
