//
//  XYAuthorityManager.swift
//  YYUIKit
//
//  Created by will on 2024/6/25.
//

/*
 功能:
  1. 请求用户授权      -- 直接请求某项权限
  2. 获取当前授权状态   -- 已经授权/已经拒绝/未决定
  3. 获取当前值        -- 如地理位置/运动健康
 */

/*
 需要在 Info.plist 中添加的 key
 
 定位权限:
 NSLocationWhenInUseUsageDescription
 
 蓝牙:
 NSBluetoothAlwaysUsageDescription      iOS 13+
 NSBluetoothPeripheralUsageDescription  iOS 12-
 
 
 
 */

import Foundation
import CoreLocation
import CoreBluetooth
import UIKit

public typealias AuthorityManager = XYAuthorityManager
@objc public class XYAuthorityManager: NSObject {
    
    @objc public static let shared: XYAuthorityManager = {
        let shared = AuthorityManager()
        return shared
    }()
    
    public typealias CompletionHandler = ((_ completion: Bool) -> Void)
    public typealias ActionHandler = (() -> Void)
    ///授权回调
    var authHandler: CompletionHandler?
    ///去设置回调
    var settingHandler: CompletionHandler?
    
    var locationManager: CLLocationManager = {
        CLLocationManager()
    }()
    
    var centralManager: CBCentralManager = {
        CBCentralManager()
    }()
    
    public override init() {
        super.init()
    }
    
    /// 是否展示去设置弹框 - 若当前权限是被拒绝, 再次请求, 弹出去设置开启的 alert
    public var shouldShowSettingAlert: Bool = true
    
    @objc public func getStatus(for auth: Auth) -> AuthStatus {
        switch auth {
        case .location:
            return self.locationAuthStatus()
        case .bluetooth:
            return self.bluetoothAuthStatus()
        default:
            break
        }
        
        // unknown
        return .notDetermined
    }
    
    @objc public func request(auth: Auth,
                              scene: String,
                              authHandler: @escaping CompletionHandler,
                              settingHandler: CompletionHandler? = nil) {
        self.authHandler = authHandler
        self.settingHandler = settingHandler
        
        self.setupAuth(auth: auth, scene: scene)
    }
}

extension AuthorityManager {
    
    private func setupAuth(auth: Auth, scene: String) {
        self.auth(auth: auth)
    }
    
    private func auth(auth: Auth) {
        switch auth {
        case .location:
            self.location()
            break
        case .bluetooth:
            self.bluetooth()
        default:
            break
        }
    }
    
    func authCompletion(_ res: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.authHandler?(res)
        }
    }
    
    func settingCompletion(_ res: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.settingHandler?(res)
        }
    }
}

// MARK: 授权页面接口
extension AuthorityManager {

    public func sceneIsAlreadyAgree(scene: String) -> Bool {
        return UserDefaults.standard.bool(forKey: scene) == true
    }
    
    public func switchScene(status: Bool, scene: String) {
        UserDefaults.standard.set(status, forKey: scene)
        UserDefaults.standard.synchronize()
    }
    
    public func isHaveAuth(auth: Auth) -> Bool {
        switch auth {
        case Auth.location:
            return isHaveLocationAuth()
//        case Auth.microphone:
//            return isHaveMicrophoneAuth()
//        case Auth.album:
//            return isHaveAlbumAuth()
//        case Auth.camera:
//            return isHaveCameraAuth()
//        case Auth.calendar:
//            return isHaveCalendarAuth()
//        case Auth.idfa:
//            return Compliance.isAllowIdfa
        default:
            return false
        }
    }
    
    public func isAuthDenied(auth: Auth) -> Bool {
        switch auth {
        case Auth.location:
            return isLocationAuthDenied()
//        case Auth.microphone:
//            return isMicrophoneAuthDenied()
//        case Auth.album:
//            return isAlbumDenied()
//        case Auth.camera:
//            return isCameraAuthDenied()
//        case Auth.calendar:
//            return isCalendarAuthDenied()
//        case Auth.idfa:
//            return isIdfaAuthDenied()
        default:
            return false
        }
    }
}

// MARK: 弹窗
extension AuthorityManager {
    
    ///系统弹框
    public func presentAlertController(title: String,
                                       message: String,
                                       confirmTitle: String,
                                       cancelTitle: String,
                                       confirmHandler: ActionHandler? = nil,
                                       cancelHandler: ActionHandler? = nil) {
        
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .default) { action in
            DispatchQueue.main.async {
                confirmHandler?()
            }
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel) { action in
            DispatchQueue.main.async {
                cancelHandler?()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        let keyWindow = UIApplication.shared.delegate?.window ?? UIApplication.shared.windows.first(where: \.isKeyWindow)
        let rootController = keyWindow?.rootViewController?.topMostViewController
        rootController?.present(alertController, animated: true)
    }
    
    ///去设置的弹窗
    func showSettingAlert() {
        if !shouldShowSettingAlert { return }
        
        showSettingAlert(title: "提示",
                         message: "前往系统设置 - \(UIApplication.shared.appName)",
                         confirmTitle: "open",
                         cancelTitle: "cancel")
    }
    
    ///去设置的弹窗
    func showSettingAlert(title: String,
                          message: String,
                          confirmTitle: String,
                          cancelTitle: String,
                          confirmHandler: ActionHandler? = nil,
                          cancelHandler: ActionHandler? = nil) {
        
        self.presentAlertController(title: title, message: message, confirmTitle: confirmTitle, cancelTitle: cancelTitle) { [weak self] in
            self?.settingCompletion(true)
            guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else {return}
            
            if UIApplication.shared.canOpenURL(settingUrl) {
                UIApplication.shared.open(settingUrl)
            }
            
        } cancelHandler: { [weak self] in
            self?.settingCompletion(false)
            
        }
    }
}

extension UIViewController {
    var topMostViewController: UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? tab
        }
        return self
    }
}
