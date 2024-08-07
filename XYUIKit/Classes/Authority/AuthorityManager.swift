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
  3. 获取当前值        -- 部分可用: 如地理位置/运动健康
 */

/*
 需要在 Info.plist 中添加的 key
 
 定位权限:
 NSLocationWhenInUseUsageDescription
 
 蓝牙:
 NSBluetoothAlwaysUsageDescription      iOS 13+
 NSBluetoothPeripheralUsageDescription  iOS 12-
 
 通知 & liveActivity:
 none
 
 健康:
 NSHealthShareUsageDescription
 NSHealthUpdateUsageDescription
 
 */

/*
 AuthorityManager 提供单例模式并推荐使用单例
 
 @note
 需要注意的是: 单例不是万能的, 同页面的多进程(原生/h5/flutter/weex)分布式请求单例, 则仅能以最后一次为准
 此类场景使用单独对象请求.
 */

import Foundation
import CoreLocation
import CoreBluetooth
import HealthKit
import UIKit

public typealias AuthorityManager = XYAuthorityManager
@objc public class XYAuthorityManager: NSObject {
    
    @objc public static let shared: XYAuthorityManager = {
        let shared = AuthorityManager()
        return shared
    }()
    
    public typealias CompletionHandler = ((_ completion: Bool) -> Void)
    public typealias ActionHandler = (() -> Void)
    
    var auth: Auth!
    var authHandler: CompletionHandler?
    var settingHandler: CompletionHandler?
    
    var locationUpdateHandler: ((CLLocation) -> Void)?
    let locationManager: CLLocationManager!
    
    lazy var centralManager: CBCentralManager = {
        let mgr = CBCentralManager()
        mgr.delegate = self
        return mgr
    }()
    lazy var healthStore: HKHealthStore! = {
        if HKHealthStore.isHealthDataAvailable() {
            let mgr = HKHealthStore()
            return mgr
        } else {
            return nil
        }
    }()
    
    public override init() {
        locationManager = .init()
        super.init()
        locationManager.delegate = self
    }
    
    /// 是否展示去设置弹框 - 若当前权限是被拒绝, 再次请求, 弹出去设置开启的 alert
    var shouldShowSettingAlert: Bool { showCustomSettingAlertHandler == nil }
    private var showCustomSettingAlertHandler: ((Auth) -> Void)?
    @objc public func setShowCustomSettingAlert(_ handler: @escaping (Auth) -> Void) {
        self.showCustomSettingAlertHandler = handler
    }
    
    
    /// 获取指定权限当前授权状态, 通知不支持同步函数, 使用 notificationAuthStatus 函数
    @objc public func getStatus(for auth: Auth) -> AuthStatus {
        switch auth {
        case .location:
            return self.locationAuthStatus()
        case .bluetooth:
            return self.bluetoothAuthStatus()
        case .notification:
            fatalError("not suppprt notification, use 'notificationAuthStatus' function")
        case .activity:
            return self.activityAuthStatus()
        case .healthStepCount:
            fatalError("not suppprt notification, use 'healthStepCountReadAuthStatus' function")
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
        self.auth = auth
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
        case .bluetooth:
            self.bluetooth()
        case .notification:
            self.notification()
        case .activity:
            self.activity()
        case .healthStepCount:
            self.healthStepCount()
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
                                       cancelTitle: String?,
                                       confirmHandler: ActionHandler? = nil,
                                       cancelHandler: ActionHandler? = nil) {
        
        DispatchQueue.main.async {
            let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let confirmAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .default) { action in
                DispatchQueue.main.async {
                    confirmHandler?()
                }
            }
            alertController.addAction(confirmAction)
            
            if let cancelTitle = cancelTitle {
                let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel) { action in
                    DispatchQueue.main.async {
                        cancelHandler?()
                    }
                }
                alertController.addAction(cancelAction)
            }
            
            let keyWindow = UIApplication.shared.delegate?.window ?? UIApplication.shared.windows.first(where: \.isKeyWindow)
            let rootController = keyWindow?.rootViewController?.topMostViewController
            rootController?.present(alertController, animated: true)
        }
    }
    
    ///去设置的弹窗
    func showSettingAlert() {
        if !shouldShowSettingAlert {
            showCustomSettingAlertHandler?(auth)
            //authCompletion(false)
            return
        }
        
        showSettingAlert(title: auth.alertTitle,
                         message: auth.alertMessage,
                         confirmTitle: auth.alertConfirmTitle,
                         cancelTitle: auth.alertCancelTitle)
    }
    
    ///去设置的弹窗
    func showSettingAlert(title: String,
                          message: String,
                          confirmTitle: String,
                          cancelTitle: String?,
                          confirmHandler: ActionHandler? = nil,
                          cancelHandler: ActionHandler? = nil) {
        
        self.presentAlertController(title: title, message: message, confirmTitle: confirmTitle, cancelTitle: cancelTitle) { [weak self] in
            if self?.auth == .healthStepCount { return } // unable to open private health settings
            
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
