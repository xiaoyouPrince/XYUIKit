//
//  XYAuthorityManager+Location.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/7/22.
//

import CoreLocation

///位置权限
extension AuthorityManager {
    
    func location() {
        switch self.locationAuthorizationStatus {
        case .notDetermined:
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            showSettingAlert()
            break
        case .authorizedAlways, .authorizedWhenInUse:
            self.authCompletion(true)
            break
        default:
            break
        }
    }
}

extension AuthorityManager: CLLocationManagerDelegate {
    var locationAuthorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return self.locationManager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationAuthorizationStatus == .notDetermined {
            return
        }
        if locationAuthorizationStatus == .authorizedWhenInUse || locationAuthorizationStatus == .authorizedAlways {
            self.authCompletion(true)
        } else {
            self.authCompletion(false)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let first = locations.first {
            
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 请求位置失败, 返回北京天安门
        
    }
}

@objc public extension AuthorityManager {
    
    @objc func locationAuthStatus() -> AuthStatus {
        if isHaveLocationAuth() {
            return .authorized
        } else if isLocationAuthDenied() {
            return .denied
        } else {
            return .notDetermined
        }
    }
    
    @objc func isHaveLocationAuth() -> Bool {
        if locationAuthorizationStatus == .authorizedAlways ||
            locationAuthorizationStatus == .authorizedWhenInUse {
            return true
        }
        return false
    }
    
    @objc func isLocationAuthDenied() -> Bool {
        if locationAuthorizationStatus == .restricted ||
            locationAuthorizationStatus == .denied {
            return true
        }
        return false
    }
    
    @objc func isLocationNotDetermined() -> Bool {
        locationAuthorizationStatus == .notDetermined
    }
    
    @objc func isCanLocation()-> Bool {
        if CLLocationManager.locationServicesEnabled() &&
            (locationAuthorizationStatus == .notDetermined ||
             locationAuthorizationStatus == .authorizedAlways ||
             locationAuthorizationStatus == .authorizedWhenInUse) {
            return true
        }
        return false
    }
}


@objc public extension AuthorityManager {
    @objc func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }
}
