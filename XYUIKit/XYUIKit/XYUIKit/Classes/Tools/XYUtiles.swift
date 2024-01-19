//
//  XYUtiles.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/1/19.
//

import Foundation

public typealias Utiles = XYUtiles
@objc public class XYUtiles: NSObject {
    
    /// 选择时间/ 中文年月日格式
    /// - Parameters:
    ///   - title: 指定一个标题
    ///   - choosenDate: 指定当前选中的时间
    ///   - callback: 选择完毕回调
    @objc public static func chooseDate(title: String,
                                        choosenDate: Date,
                                        callback:@escaping (Date)->()) {
        XYDatePickerTool.chooseDate(title: title, choosenDate: choosenDate) { date in
            callback(date)
        }
        
    }
    
    
}
