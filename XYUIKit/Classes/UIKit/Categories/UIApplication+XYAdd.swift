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
    static var keyWindow_: UIWindow? { shared.keyWindow_ }
    
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
    static var snapShot: UIImage? { shared.snapShot }
    var snapShot: UIImage? {
        UIApplication.shared.getKeyWindow()?.snapshotImage
    }
    
    /// 获取当前App的命名空间
    static var nameSpase: String { shared.nameSpase }
    var nameSpase: String {
        let man = UIApplication.shared.delegate!.description
        let start = man.index(after: man.startIndex)
        let end = man.firstIndex(of: ".")!
        let nameSpace = man[start..<end]
        return String(nameSpace)
    }
    
    /// 获取 keyWindow
    /// - Returns: keyWindow
    static func getKeyWindow() -> UIWindow? { shared.getKeyWindow() }
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
    func suspend() {
        DispatchQueue.main.async {
            if UIApplication.shared.applicationState != .background {
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            }
        }
    }
    
    /// 去应用设置页面
    static func openSettings() { shared.openSettings() }
    func openSettings() {
        let app = UIApplication.shared
        if let setingUrl = URL(string: UIApplication.openSettingsURLString),
           app.canOpenURL(setingUrl)
        {
            app.open(setingUrl)
        }
    }
    
    /// App build 版本号
    static var appBuildVersion: Int { shared.appBuildVersion }
    var appBuildVersion: Int {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? Int ?? 1
    }
    
    /// App 版本号（App Store 展示的发布版本号如 1.2.0）
    static var appVersion: String { shared.appVersion }
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

}

