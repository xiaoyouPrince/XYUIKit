//
//  XYAuthType.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/7/22.
//

import Foundation

//
//@objc public class Auth: NSObject {
//    @objc public static let location = "location"
//    @objc public static let microphone = "microphone"
//    @objc public static let album = "album"
//    @objc public static let camera = "camera"
//    @objc public static let calendar = "calendar"
//    @objc public static let idfa = "idfa"
//}

@objc public enum AuthStatus: Int {
    case authorized
    case denied
    case notDetermined
}

@objc public enum Auth: Int {
    case location = 0
    case bluetooth
    case health
    case notification
    case activity   // iOS 16.2+
    
    case unknown
    
    public init?(rawValue: Int) {
        switch rawValue {
        case Auth.location.rawValue:
            self = .location
        case Auth.bluetooth.rawValue:
            self = .bluetooth
        case Auth.health.rawValue:
            self = .health
        case Auth.notification.rawValue:
            self = .notification
        case Auth.activity.rawValue:
            self = .activity

        default:
            self = .unknown
        }
    }
    
//    public typealias RawValue = Int
    
}
