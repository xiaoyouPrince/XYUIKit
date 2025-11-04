//
//  KeyboardMonitor.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/6/11.
//
//  一个简单的键盘状态监听工具

/* ************************* USAGE *************************
 
     // 初始化 KeyboardMonitor
     keyboardMonitor = KeyboardMonitor()
     
     // 设置键盘状态回调
     keyboardMonitor?.keyboardWillShow = { startFrame, endFrame, duration in
         print("Keyboard will show from frame: \(startFrame) to frame: \(endFrame) with duration: \(duration)")
     }
     
     keyboardMonitor?.keyboardDidShow = { startFrame, endFrame, duration in
         print("Keyboard did show from frame: \(startFrame) to frame: \(endFrame) with duration: \(duration)")
     }
     
     keyboardMonitor?.keyboardWillHide = { startFrame, endFrame, duration in
         print("Keyboard will hide from frame: \(startFrame) to frame: \(endFrame) with duration: \(duration)")
     }
     
     keyboardMonitor?.keyboardDidHide = { startFrame, endFrame, duration in
         print("Keyboard did hide from frame: \(startFrame) to frame: \(endFrame) with duration: \(duration)")
     }
 
     keyboardMonitor?.keyboardWillChangeFrame = { startFrame, endFrame, duration in
         print("Keyboard did hide from frame: \(startFrame) to frame: \(endFrame) with duration: \(duration)")
     }
 */

import UIKit

public class KeyboardMonitor {
    public typealias KeyboardMonitorCallBack = ((_ startFrame: CGRect, _ endFrame: CGRect, _ duration: Double) -> Void)
    
    // 键盘状态回调
    public var keyboardWillShow: KeyboardMonitorCallBack?
    public var keyboardDidShow: KeyboardMonitorCallBack?
    public var keyboardWillHide: KeyboardMonitorCallBack?
    public var keyboardDidHide: KeyboardMonitorCallBack?
    public var keyboardWillChangeFrame: KeyboardMonitorCallBack?
    
    public init() {
        // 监听键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowNotification(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHideNotification(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrameNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        // 移除通知监听
        NotificationCenter.default.removeObserver(self)
    }
}

extension KeyboardMonitor {
    // 键盘即将显示
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let startFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
           let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            keyboardWillShow?(startFrame, endFrame, duration)
        }
    }
    
    // 键盘已经显示
    @objc private func keyboardDidShowNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let startFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
           let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            keyboardDidShow?(startFrame, endFrame, duration)
        }
    }
    
    // 键盘即将隐藏
    @objc private func keyboardWillHideNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let startFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
           let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            keyboardWillHide?(startFrame, endFrame, duration)
        }
    }
    
    // 键盘已经隐藏
    @objc private func keyboardDidHideNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let startFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
           let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            keyboardDidHide?(startFrame, endFrame, duration)
        }
    }
    
    // 键盘已经隐藏
    @objc private func keyboardWillChangeFrameNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let startFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
           let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            keyboardWillChangeFrame?(startFrame, endFrame, duration)
        }
    }
}
