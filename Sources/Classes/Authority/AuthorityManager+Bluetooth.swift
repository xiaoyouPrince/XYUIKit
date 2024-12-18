//
//  AuthorityManager+Bluetooth.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/7/22.
//

import CoreBluetooth

///蓝牙权限
extension AuthorityManager {

    func bluetooth() {
        
        if #available(iOS 13.1, *) {
            let authorization = CBCentralManager.authorization
            switch authorization {
            case .notDetermined:
                _ = self.centralManager
                break // 蓝牙由系统弹申请框
            case .restricted, .denied:
                self.showSettingAlert()
                // 蓝牙状态由代理同步，所以每次需要回调状态
                self.authCompletion(false)
                break
            case .allowedAlways:
                self.authCompletion(true)
                break
            default:
                break
            }
        } else {
            // Fallback on earlier versions
            let status = centralManager.state
            switch status {
            case .unknown, .resetting, .unsupported, .unauthorized, .poweredOff:
                self.authCompletion(false)
            case .poweredOn:
                self.authCompletion(true)
            @unknown default:
                self.authCompletion(false)
            }
        }
    }
}

extension AuthorityManager: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        bluetooth()
    }
}

@objc public extension AuthorityManager {
    
    @objc func bluetoothAuthStatus()-> AuthStatus {
        
        if #available(iOS 13.1, *) {
            let auth = CBCentralManager.authorization
            switch auth {
            case .notDetermined:
                return .notDetermined
            case .restricted, .denied:
                return .denied
            case .allowedAlways:
                return .authorized
            @unknown default:
                fatalError("unknow bluetooth authorization")
            }
        } else {
            // Fallback on earlier versions
            if centralManager.state == .poweredOn {
                return .authorized
            } else {
                return .denied
            }
        }
    }
}
