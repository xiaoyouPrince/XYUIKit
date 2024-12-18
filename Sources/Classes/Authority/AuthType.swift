//
//  XYAuthType.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/7/22.
//

import Foundation
import UIKit

@objc public enum AuthStatus: Int {
    case authorized
    case denied
    case notDetermined
}

@objc public enum Auth: Int {
    case location = 0
    case bluetooth
    case healthStepCount
    case notification
    case activity   // iOS 16.2+
    
    case unknown
    
    public init?(rawValue: Int) {
        switch rawValue {
        case Auth.location.rawValue:
            self = .location
        case Auth.bluetooth.rawValue:
            self = .bluetooth
        case Auth.healthStepCount.rawValue:
            self = .healthStepCount
        case Auth.notification.rawValue:
            self = .notification
        case Auth.activity.rawValue:
            self = .activity

        default:
            self = .unknown
        }
    }
    
    var alertTitle: String {
        var result = "unknown"
        switch self {
        case .location:
            result = "未开启定位"
        case .bluetooth:
            result = "未开启蓝牙"
        case .healthStepCount:
            result = "无法访问健康数据"
        case .notification:
            result = "未开启通知"
        case .activity:
            result = "未开启实时活动"
        case .unknown:
            result = "unknown"
        }
        return result
    }
    
    var alertMessage: String {
        var result = "unknown"
        switch self {
        case .location:
            result = "请在系统设置中打开定位, 以保证应用内基于位置的服务正常使用"
        case .bluetooth:
            result = "请在系统设置中打开蓝牙, 以保证应用内蓝牙状态正常展示"
        case .healthStepCount:
            result = "请到系统设置-隐私-健康-\(UIApplication.appName)中, 允许读取步数" 
        case .notification:
            result = "请在系统设置中打开通知, 以保证桌面语音通知正常显示"
        case .activity:
            result = "请在系统设置中打开实时活动, 以保证桌面实时活动正常显示"
        case .unknown:
            result = "unknown"
        }
        return result
    }
    
    var alertConfirmTitle: String {
        var result = "open"
        switch self {
        case .location:
            result = "去设置"
        case .bluetooth:
            result = "去设置"
        case .healthStepCount:
            result = "确定" // 确定即取消
        case .notification:
            result = "去设置"
        case .activity:
            result = "去设置"
        case .unknown:
            result = "unknown"
        }
        return result
    }
    
    var alertCancelTitle: String? {
        var result: String? = "cancel"
        switch self {
        case .location:
            result = "取消"
        case .bluetooth:
            result = "取消"
        case .healthStepCount:
            result = nil
        case .notification:
            result = "取消"
        case .activity:
            result = "取消"
        case .unknown:
            result = "unknown"
        }
        return result
    }
}
