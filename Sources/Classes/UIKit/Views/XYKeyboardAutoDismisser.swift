//
//  XYKeyboardAutoDismisser.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2025/8/20.
//

/*
 监听主 RunLoop 进入 Tracking 模式并自动收起键盘
 
 开始监听
 KeyboardAutoDismisser.shared.startMonitoring()
 
 停止监听
 KeyboardAutoDismisser.shared.stopMonitoring()
 
 注意事项:
 这个工具会在整个应用范围内生效，如果只需要在特定界面使用，可以在相应控制器的 viewWillAppear 和 viewWillDisappear 中开启/关闭监听
 对于复杂的界面交互，可能需要更精细的控制逻辑
 */

import Foundation
import UIKit

public typealias KeyboardAutoDismisser = XYKeyboardAutoDismisser
public final class XYKeyboardAutoDismisser {
    private var observer: CFRunLoopObserver?
    private let tapDebouncer: TapDebouncer = .default
    
    public static let shared = XYKeyboardAutoDismisser()
    private init() {}
    
    public func startMonitoring() {
        startMonitoring__()
    }
    
    public func stopMonitoring() {
        stopMonitoring__()
    }
    
    deinit {
        stopMonitoring()
    }
}

extension XYKeyboardAutoDismisser {
    private func startMonitoring__() {
        // 如果已有观察者，先移除
        stopMonitoring()
        
        // 创建 RunLoop 观察者
        let activities: CFRunLoopActivity = .beforeWaiting
        let observer = CFRunLoopObserverCreateWithHandler(
            kCFAllocatorDefault,
            activities.rawValue,
            true,
            0
        ) { [weak self] (observer, activity) in
            self?.handleRunLoopActivity(activity)
        }
        
        // 将观察者添加到主 RunLoop 的 common modes
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, .commonModes)
        self.observer = observer
    }
    
    private func stopMonitoring__() {
        if let observer = observer {
            CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, .commonModes)
            self.observer = nil
        }
    }
    
    private func handleRunLoopActivity(_ activity: CFRunLoopActivity) {
        // 检查是否处于 tracking 模式
        // 需要注意的是这里调用会非常频繁, runloop 级别的调用, 处理事件要尽可能轻量级
        if RunLoop.current.currentMode == .tracking {
            // print("handleRunLoopActivity ---- date\(Date().timeIntervalSince1970)")
            tapDebouncer.executeIfAllowed { [weak self] in
                //print("handleRunLoopActivity 实际被执行的 ---- date\(Date().timeIntervalSince1970)")
                // 检测是否有 ScrollView 正在滚动
                if let scrollingView = self?.findScrollingView() {
                    //print("Scrolling detected in: \(scrollingView)")
                    self?.dismissKeyboard()
                }
            }
        }
    }
    
    private func dismissKeyboard() {
        // 获取当前的第一响应者
        if let firstResponder = findFirstResponder() {
            //print("Dismissing keyboard for: \(firstResponder)")
            firstResponder.resignFirstResponder()
        }
    }
    
    private var keywindow: UIWindow? {
        UIApplication.shared.getKeyWindow()
    }
    
    private func findFirstResponder() -> UIView? {
        if let window = keywindow {
            if let firstResponder = findFirstResponder(in: window) {
                return firstResponder
            }
        }
        return nil
    }
    
    private func findFirstResponder(in view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }
        
        for subview in view.subviews {
            if let firstResponder = findFirstResponder(in: subview) {
                return firstResponder
            }
        }
        
        return nil
    }
    
    private func findScrollingView() -> UIScrollView? {
        if let window = keywindow {
            if let scrollView = findScrollingView(in: window) {
                return scrollView
            }
        }
        return nil
    }
    
    private func findScrollingView(in view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView, scrollView.isDragging || scrollView.isDecelerating || scrollView.isTracking {
            return scrollView
        }
        
        for subview in view.subviews {
            if let scrollView = findScrollingView(in: subview) {
                return scrollView
            }
        }
        return nil
    }
}
