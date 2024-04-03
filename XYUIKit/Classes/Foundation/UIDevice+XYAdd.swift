//
//  UIDevice+XYAdd.swift
//  YYUIKit
//
//  Created by will on 2024/1/3.
//

import Foundation

public extension UIScreen {
    /// The natural scale factor associated with the main screen.
    static let screenScale: CGFloat = UIScreen.main.scale
    
    @available(iOS 12.0, *)
    static var userInterfaceStyle: UIUserInterfaceStyle {
        UIScreen.main.traitCollection.userInterfaceStyle
    }
}


public extension UIDevice {
    /// 获取用户设置的时间格式是否是 24 小时制
    static var is24HourFormat: Bool {  Date.is24HourFormat }
    
    /// 当前设备语言是否是中文
    static var isCurrentLanguageZH: Bool {
        let lang = Locale.current.languageCode // zh en
        return lang == "zh"
    }
}
