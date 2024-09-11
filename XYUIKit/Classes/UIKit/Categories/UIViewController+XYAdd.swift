//
//  UIViewController+XYAdd.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2022/5/4.
//

import Foundation


/// 获取当前可见的控制器
/// - Note: 需要注意的, 此方法适用于当前有 keyWindow 的场景, 如果没有找到 keyWindow 返回nil, 在一些特殊场景慎用,可以先提前获取 currenVC 并暂存, 在需要的场景使用, 比如画中画场景系统会修改App.keywindow
/// - Returns: UIViewController
public func currentVisibleController() -> UIViewController! {
    if !Thread.isMainThread {
        let semaphore = DispatchSemaphore(value: 0)
        var keyWindow: UIWindow? = nil
        var result: UIViewController? = nil
        DispatchQueue.main.async {
            for window in UIApplication.shared.windows {
                if window.isKeyWindow {
                    keyWindow = window
                    break
                }
            }
            result = findTopViewController(from: keyWindow)
            semaphore.signal()
        }
        semaphore.wait()
        return result
    } else {
        var keyWindow: UIWindow? = nil
        for window in UIApplication.shared.windows {
            if window.isKeyWindow {
                keyWindow = window
                break
            }
        }
        return findTopViewController(from: keyWindow)
    }
}

fileprivate func findTopViewController(from keyWindow: UIWindow?) -> UIViewController? {
    guard let keyWindow = keyWindow, var topController = keyWindow.rootViewController else { return nil }
    
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

public extension UIViewController {
    
    /// 获取当前可见的控制器
    /// - Note: 需要注意的, 此方法适用于当前有 keyWindow 的场景, 如果没有找到 keyWindow 返回 nil, 在一些特殊场景慎用,可以先提前获取 currenVC 并暂存, 在需要的场景使用, 比如画中画场景系统会修改App.keywindow
    static var currentVisibleVC: UIViewController! {
        currentVisibleController()
    }
    
}
