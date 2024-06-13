//
//  CGFloat+XYAdd.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2023/6/19.
//

import UIKit

extension CGFloat {
    
    /// 屏幕宽
    public static let width = UIScreen.main.bounds.width
    
    /// 屏幕高
    public static let height = UIScreen.main.bounds.height
    
    /// 状态栏高度
    public static var statusBar: CGFloat {
        if Thread.isMainThread {
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
                return window?.safeAreaInsets.top ?? 44
            } else {
                return UIApplication.shared.statusBarFrame.height
            }
        } else {
            let semaphore = DispatchSemaphore(value: 0)
            var result: CGFloat = 44
            DispatchQueue.main.async {
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
                    result = window?.safeAreaInsets.top ?? 44
                } else {
                    result = UIApplication.shared.statusBarFrame.height
                }
                semaphore.signal()
            }
            semaphore.wait()
            return result
        }
    }
    
    /// 导航条高度 44
    public static let naviHeight: CGFloat = 44
    
    /// 导航栏高度 statusBar + naviHeight
    public static let naviBar = naviHeight + statusBar
    
    /// 底部安全区 高度
    public static var safeBottom: CGFloat {
        if Thread.isMainThread {
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
                return window?.safeAreaInsets.bottom ?? 0
            } else {
                return 0
            }
        } else {
            let semaphore = DispatchSemaphore(value: 0)
            var result: CGFloat = 0
            DispatchQueue.main.async {
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
                    result = window?.safeAreaInsets.bottom ?? 0
                } else {
                    result = 0
                }
                semaphore.signal()
            }
            semaphore.wait()
            return result
        }
    }
    
    /// 顶部安全区 高度
    public static var safeTop: CGFloat {
        if Thread.isMainThread {
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
                return window?.safeAreaInsets.top ?? 0
            } else {
                return 0
            }
        } else {
            let semaphore = DispatchSemaphore(value: 0)
            var result: CGFloat = 0
            DispatchQueue.main.async {
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
                    result = window?.safeAreaInsets.top ?? 0
                } else {
                    result = 0
                }
                semaphore.signal()
            }
            semaphore.wait()
            return result
        }
    }
    
    /// 刘海屏
    public static var isIPhoneX: Bool {
        safeBottom > 0
    }
    
    /// 灵动岛屏幕  safeTop 59pt
    public static var isDynamicIsland: Bool {
        safeTop >= 59
    }
    
    /// 屏幕适配
    public static func getRealValue(value: CGFloat) -> CGFloat {
        return value / 375.0 * UIScreen.main.bounds.size.width
    }
    
    /// 屏幕宽高比
    public static var whRatio: CGFloat {
        return .width / .height
    }
    
    /// tabBar 高度
    public static let tabBar = safeBottom + 49
    
    /// 一像素横线高度
    public static let line = 1.0 / UIScreen.main.scale
}


public protocol AutoFitProtocol {}
public extension AutoFitProtocol {
    var fit_width: Double {
        get {
            let KScreenWidth = UIScreen.main.bounds.width
            let referenceWidth: CGFloat = 375.0
            
            if let realSelf = self as? Int {
                return CGFloat(Double(KScreenWidth) / Double(referenceWidth)) * Double(realSelf)
            }

            if let realSelf = self as? CGFloat {
                return CGFloat(Double(KScreenWidth) / Double(referenceWidth)) * Double(realSelf)
            }

            if let realSelf = self as? Float {
                return CGFloat(Double(KScreenWidth) / Double(referenceWidth)) * Double(realSelf)
            }

            if let realSelf = self as? Double {
                return CGFloat(Double(KScreenWidth) / Double(referenceWidth)) * Double(realSelf)
            }
            
            return 0
        }
    }
    
    var fit_height: Double {
        get {
            let screenHeight = UIScreen.main.bounds.height
            let referenceheight: CGFloat = 667.0
            
            if let realSelf = self as? Int {
                return CGFloat(Double(screenHeight) / Double(referenceheight)) * Double(realSelf)
            }
            
            if let realSelf = self as? CGFloat {
                return CGFloat(Double(screenHeight) / Double(referenceheight)) * Double(realSelf)
            }
            
            if let realSelf = self as? Float {
                return CGFloat(Double(screenHeight) / Double(referenceheight)) * Double(realSelf)
            }
            
            if let realSelf = self as? Double {
                return CGFloat(Double(screenHeight) / Double(referenceheight)) * Double(realSelf)
            }
            
            return 0
        }
    }
}

extension Int: AutoFitProtocol {}
extension CGFloat: AutoFitProtocol {}
extension Float: AutoFitProtocol {}
extension Double: AutoFitProtocol {}


