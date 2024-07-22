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
//        switch self.locationAuthorizationStatus {
//        case .notDetermined:
//            self.locationManager.delegate = self
//            self.locationManager.requestWhenInUseAuthorization()
//            break
//        case .restricted, .denied:
//            showSettingAlert()
//            break
//        case .authorizedAlways, .authorizedWhenInUse:
//            self.authCompletion(true)
//            break
//        default:
//            break
//        }
        
        
        
        
        if #available(iOS 13.1, *) {
            let authorization = CBCentralManager.authorization
            switch authorization {
            case .notDetermined:
                self.centralManager.delegate = self
            case .restricted, .denied:
                self.showSettingAlert()
                break
            case .allowedAlways:
                self.authCompletion(true)
                break
            default:
                break
            }
        } else {
            // Fallback on earlier versions
            var status = centralManager.state
        }
        
        
        switch centralManager.state {
        case .unknown:
            print("蓝牙状态未知")
        case .resetting:
            print("蓝牙状态重置中")
        case .unsupported:
            print("不支持蓝牙")
        case .unauthorized:
            print("蓝牙未授权")
        case .poweredOff:
            print("蓝牙已关闭")
        case .poweredOn:
            print("蓝牙已打开")
        @unknown default:
            print("未知蓝牙状态")
        }
    }
}

extension AuthorityManager: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
//        Toast("\(central.state)") 
        print(central.state)
        
        
    }
}

@objc public extension AuthorityManager {
    
//    ///检查定位权限
//    @objc func isHaveLocationAuth() -> Bool {
//        if locationAuthorizationStatus == .authorizedAlways ||
//            locationAuthorizationStatus == .authorizedWhenInUse {
//            return true
//        }
//        return false
//    }
//    
//    @objc func isLocationAuthDenied() -> Bool {
//        if locationAuthorizationStatus == .restricted ||
//            locationAuthorizationStatus == .denied {
//            return true
//        }
//        return false
//    }
//    
//    @objc func isLocationNotDetermined() -> Bool {
//        locationAuthorizationStatus == .notDetermined
//    }
    
    //    @objc func shouldShowLocationAlert(scene: String) -> Bool {
    //        self.sceneModel = Authoritation.sceneModel(auth: "location",
    //                                                   scene: scene,
    //                                                   json: self.datasources)
    //        let sceneCacheKey: String = self.sceneModel?.scene ?? ""
    //        return !UserDefaults.standard.bool(forKey: sceneCacheKey)
    //    }
    
    
    
//    @objc func isCanLocation()-> Bool {
//        if CLLocationManager.locationServicesEnabled() &&
//            (locationAuthorizationStatus == .notDetermined ||
//             locationAuthorizationStatus == .authorizedAlways ||
//             locationAuthorizationStatus == .authorizedWhenInUse) {
//            return true
//        }
//        return false
//    }
    
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
            // todo -- iOS 12-
            if centralManager.state == .unauthorized {
                return .notDetermined
            } else {
                return .notDetermined
            }
        }
    }
}
