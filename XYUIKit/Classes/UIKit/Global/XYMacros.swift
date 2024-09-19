//
//  XYMacros.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2022/5/5.
//

import UIKit

// MARK: - 一些常量宏
// 理论上使用上层常量效率更高，其仅在首次调用时执行底层代码，并将结果值存储到常量之后，后续再使用的也只是存储的值

public let iPhoneX: Bool = CGFloat.isIPhoneX
public let kStatusBarH: CGFloat = .statusBar
public let kNavBarH: CGFloat = .naviHeight
public let kNavHeight: CGFloat = kStatusBarH + kNavBarH
public let kTabbarH: CGFloat = .tabBar
public let kTabSafeH: CGFloat = .safeBottom

public let kScreenW: CGFloat = .width
public let kScreenH: CGFloat = .height




