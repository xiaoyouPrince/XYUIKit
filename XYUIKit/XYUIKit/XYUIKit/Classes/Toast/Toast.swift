//
//  Toast.swift
//  Pods-Toast_Example
//
//  Created by lei.ren on 2021/8/16.
//

import Foundation
import UIKit

public struct Toast {
    
    static var shared = Toast()
    
    init() {
        ToastManager.shared.isTapToDismissEnabled = false
        ToastManager.shared.position = .center
        ToastManager.shared.duration = 2.0

        var style = ToastStyle()
        style.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 0.8)
        style.cornerRadius = 8
        style.messageColor = .white
        style.messageFont = .systemFont(ofSize: 16)
        style.messageAlignment = .center
        style.maxWidthPercentage = 0.68
        style.horizontalPadding = 18
        
        style.activityBackgroundColor = style.backgroundColor
        style.activitySize = CGSize(width: 80, height: 80)
        
        ToastManager.shared.style = style
    }
    
    var window: UIView? {
        
        if #available(iOS 15.0, *) {
            var keyWindow: UIWindow? = nil
            
            var allScene: [UIWindowScene] = []
            for scene in UIApplication.shared.connectedScenes {
                if scene is UIWindowScene, let ws = scene as? UIWindowScene {
                    allScene.append(ws)
                }
            }
            for ws in allScene {
                if let kw = ws.keyWindow {
                    keyWindow = kw
                }
            }
            
            return keyWindow ?? UIApplication.shared.windows.first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.windows.first(where: \.isKeyWindow)
        }
    }
    
    func make(_ message: String,
              image: UIImage? = nil,
              duration: TimeInterval,
              in view: UIView? = nil,
              completion: (() -> Void)?) {

        DispatchQueue.safeMain {

            guard message.isEmpty == false || image != nil else {
                return
            }
            guard let inView = (view ?? window) else {
                return
            }
            
            inView.hideAllToasts()
            
            if let _ = image {
                ToastManager.shared.style.verticalPadding = 15
            } else {
                ToastManager.shared.style.maxWidthPercentage = 0.68
                ToastManager.shared.style.verticalPadding = 11
            }
            guard let toast = inView.toastCustomViewForMessage(message, image: image, in: inView) else {
                return
            }
            
            inView.showToast(toast, duration: duration) { _ in
                completion?()
            }
        }
    }
}

public extension Toast {
    
    /// 显示一个文字或图片（默认2秒后消失）
    static func make(_ message: String, image named: String? = nil, duration: TimeInterval = 2, in view: UIView? = nil, completion: (() -> Void)? = nil) {
        var image: UIImage?
        if let named = named {
            image = UIImage(named: named)
        }
        shared.make(message, image: image, duration: duration, in: view, completion: completion)
    }
}


public extension Toast {
    
    /// 活动指示器（触摸事件关闭）
    static func makeActivity(in view: UIView? = nil) {
        DispatchQueue.safeMain {
            guard let inView = (view ?? shared.window) else {
                return
            }
            inView.makeToastActivity(.center)
            
            inView.isUserInteractionEnabled = false
        }
    }
    
    /// 取消显示活动指示器（触摸事件打开）
    static func hideActivity(in view: UIView? = nil) {
        DispatchQueue.safeMain {
            guard let inView = (view ?? shared.window) else {
                return
            }
            inView.hideToastActivity()
            
            inView.isUserInteractionEnabled = true
        }
    }
}

public extension Toast {
    
    /// DEBUG下显示
    static func makeDebug(_ message: String, image named: String? = nil, duration: TimeInterval = 2, in view: UIView? = nil) {
        #if DEBUG
        make("Debug: \(message)", image: named, duration: duration, in: view)
        #endif
    }
}


extension DispatchQueue {
    
    static var token: DispatchSpecificKey<()> = {
        let key = DispatchSpecificKey<()>()
        DispatchQueue.main.setSpecific(key: key, value: ())
        return key
    }()
    
    static var isMain: Bool {
        DispatchQueue.getSpecific(key: token) != nil
    }
    
    /// 主队列执行
    public static func safeMain(_ block: @escaping () ->()) {
        if DispatchQueue.isMain {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
