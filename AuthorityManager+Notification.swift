//
//  AuthorityManager+Notification.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/7/23.
//

import UserNotifications

///通知权限 - 本地通知
extension AuthorityManager {
    
    func notification() {
        notificationAuthStatus {[weak self] currentStatus in
            switch currentStatus {
            case .authorized:
                self?.authCompletion(true)
            case .denied:
                self?.showSettingAlert()
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) {[weak self] granted, error in
                    self?.authCompletion(granted)
                }
            }
        }
    }
}


@objc public extension AuthorityManager {
    
    @available(iOS 13.0.0, *)
    @objc func notificationAuthStatus() async -> AuthStatus {
        
        var status = AuthStatus.notDetermined
        let status_ : UNNotificationSettings = await UNUserNotificationCenter.current().notificationSettings()
        
        switch status_.authorizationStatus {
        case .notDetermined:
            status = .notDetermined
        case .denied:
            status = .denied
        case .authorized:
            status = .authorized
        case .provisional:
            status = .authorized
        case .ephemeral:
            status = .authorized
        @unknown default:
            status = .notDetermined
        }
        
        return status
    }
    
    @objc func notificationAuthStatus(_ callback: @escaping (AuthStatus) -> ()) {
        
        UNUserNotificationCenter.current().getNotificationSettings { notiSettings in
            let status = notiSettings.authorizationStatus
            switch status {
            case .notDetermined:
                callback(.notDetermined)
            case .denied:
                callback(.denied)
            case .authorized:
                callback(.authorized)
            case .provisional:
                callback(.authorized)
            case .ephemeral:
                callback(.authorized)
            @unknown default:
                callback(.notDetermined)
            }
        }
    }
}
