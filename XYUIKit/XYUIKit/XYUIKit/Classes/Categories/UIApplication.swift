//
//  UIApplication.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2023/9/27.
//

import UIKit

extension UIApplication {
    
    /// 获取 keyWindow
    /// - Returns: keyWindow
    func getKeyWindow() -> UIWindow? {
        if #available(iOS 15.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            return window
        }else {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            return window
        }
    }
}

