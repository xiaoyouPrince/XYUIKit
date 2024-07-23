//
//  AuthorityManager+Activity.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/7/23.
//
/*
 iOS 16.1 之后可用, 为保证 AuthorityManager 使用的一致性, 在低版本系统状态返回 .deny
 
 实时活动, 没有授权概念, 系统默认开启, 用户可以在设置中手动开启/关闭. 此模块核心只是封装当前实时活动是否可用
 
 实时活动本质是 widget extension 的一种, 其更新机制不依赖 timeline, 如果业务上使用 activity 参考:
 https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities
 
 对于所谓的授权, 上述支持实时活动场景下, 用户只需要直接使用即可. 如直接 start/update/end 活动
 设置中可见实时活动权限开关, 否则开关默认开启且不可见
 */

import ActivityKit

/// 实时活动
extension AuthorityManager {
    
    func activity() {
        if #available(iOS 16.2, *) {
            self.authCompletion(areActivitiesEnabled())
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
