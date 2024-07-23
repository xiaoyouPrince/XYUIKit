//
//  AuthorityManager+Activity.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/7/23.
//
/*
 iOS 16.1 之后可用, 为保证 AuthorityManager 使用的一致性, 在低版本系统状态返回 .deny
 
 实时活动, 没有授权概念, 系统默认开启, 用户可以在设置中手动开启/关闭
 此模块核心只是封装当前实时活动是否可用
 */

import ActivityKit

/// 实时活动
extension AuthorityManager {
    
    func activity() {
        if #available(iOS 16.1, *) {
            if areActivitiesEnabled() {
                self.authCompletion(true)
            } else {
                self.showSettingAlert()
            }
        } else {
            // not support, update iOS version
        }
    }
}

@objc public extension AuthorityManager {
    
    /// 灵动岛通知是否开启
    /// - Returns: true is open，else close
    func areActivitiesEnabled() -> Bool {
        if #available(iOS 16.1, *) {
            return ActivityAuthorizationInfo().areActivitiesEnabled
        } else {
            return false
        }
    }
    
    @objc func activityAuthStatus() -> AuthStatus {
        var status = AuthStatus.denied
        if areActivitiesEnabled() {
            status = .authorized
        }
        return status
    }
}
