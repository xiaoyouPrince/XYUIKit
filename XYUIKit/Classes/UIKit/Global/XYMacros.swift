//
//  XYMacros.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2022/5/5.
//

import UIKit

// MARK:-一些常量宏

func navHeight() -> CGFloat {
    if #available(iOS 13.0, *) {
        return UIApplication.shared.keyWindow_?.windowScene?.statusBarManager?.statusBarFrame.height ?? UIApplication.shared.statusBarFrame.height
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}

func tabbarSafeHeight() -> CGFloat {
    isIPhoneX() ? 34 : 0
}

func isIPhoneX() -> Bool {
    navHeight() != 20
}

public let iPhoneX = isIPhoneX()
public let kStatusBarH = navHeight()
public let kNavBarH : CGFloat = 44
public let kNavHeight : CGFloat = kStatusBarH + kNavBarH
public let kTabbarH : CGFloat = 49
public let kTabSafeH : CGFloat = tabbarSafeHeight()

public let kScreenW : CGFloat = UIScreen.main.bounds.width
public let kScreenH : CGFloat = UIScreen.main.bounds.height




