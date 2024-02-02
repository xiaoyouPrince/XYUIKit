//
//  UIApplication+XYAdd.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2023/9/27.
//

import UIKit

public extension UIApplication {
    
    /// 获取 keyWindow
    @available(iOS 13.0, *)
    var keyWindow_: UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter{$0.activationState == .foregroundActive}
            .compactMap { $0 as? UIWindowScene }
        let window = connectedScenes.first?
            .windows
            .first{ $0.isKeyWindow }
        return window
    }
    
    /// 获取当前 App 的截图
    var snapShot: UIImage? {
        UIApplication.shared.getKeyWindow()?.snapshotImage
    }
    
}

public extension UIApplication {
    
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
    
    
    
    /// 挂起 App
    static func suspend() { shared.suspend() }
    /// 挂起 App
    func suspend() {
        DispatchQueue.main.async {
            if UIApplication.shared.applicationState != .background {
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            }
        }
    }

}

