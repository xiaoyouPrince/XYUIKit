//
//  CompatibleToast.swift
//  ToastUtils
//
//  Created by lei.ren on 2022/3/2.
//

import Foundation

/// OC兼容Toast调用，Swift直接使用 `Toast`
public class CompatibleToast: NSObject {
    
    /// 显示一个文字或图片（默认2秒后消失）
    @objc public static func make(_ message: String,
                            image named: String? = nil,
                            duration: TimeInterval = 2,
                            inView: UIView? = nil) {
        Toast.make(message, image: named, duration: duration, in: inView)
    }
    
    /// `Debug` 下显示一个文字或图片（默认2秒后消失）
    @objc public static func makeDebug(_ message: String,
                            image named: String? = nil,
                            duration: TimeInterval = 2,
                            inView: UIView? = nil) {
        Toast.makeDebug(message, image: named, duration: duration, in: inView)
    }
    
    /// 活动指示器（触摸事件关闭）
    @objc public static func makeActivity(inView: UIView? = nil) {
        Toast.makeActivity(in: inView)
    }
    
    /// 取消显示活动指示器（触摸事件打开）
    @objc public static func hideActivity(inView: UIView? = nil) {
        Toast.hideActivity(in: inView)
    }
}
