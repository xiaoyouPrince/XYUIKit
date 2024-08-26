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
            self.locationUpdateHandler?(first)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 请求位置失败, 返回北京天安门
        let bj_tam = CLLocation.init(latitude: 39.54, longitude: 116.23)
        self.locationUpdateHandler?(bj_tam)
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
    
    /// 获取当前 GPS 定位
    /// - Parameter complete: 定位完成回调， 如果定位失败返回 北京位置信息
    @objc func getCurrentLocation(complete: @escaping (CLLocation) -> Void) {
        self.auth = .location
        
        let status = locationAuthStatus()
        switch status {
        case .authorized:
            requestCurrentLocation(complete: complete)
        case .denied:
            showSettingAlert()
        case .notDetermined:
            request(auth: .location, scene: "") {[weak self] completion in
                self?.getCurrentLocation(complete: complete)
            }
        }
    }
    
    private func requestCurrentLocation(complete: @escaping (CLLocation) -> Void) {
        self.locationUpdateHandler = complete
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100
        
        if let location = locationManager.location {
            if Date().timeIntervalSince1970 - location.timestamp.timeIntervalSince1970 > 300 {
                locationManager.requestLocation()
            } else {
                complete(location)
            }
        } else {
            locationManager.requestLocation()
        }
    }
}
