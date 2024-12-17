//
//  AuthorityManager+Health.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/7/23.
//

/*
 当前版本仅常规权限: 步数
 
 由于健康数据包含较多个人敏感数据, 具体需要业务上处理. 关于 HealthKit 配置:
 https://developer.apple.com/documentation/healthkit/setting_up_healthkit
 https://developer.apple.com/documentation/healthkit/authorizing_access_to_health_data
 
 由于健康数据隐私性较强, 苹果保护严格, 这里策略调整如下
 1. 仅申请步数读取权限, 写权限用不到, 如果申请可能审核失败.
 2. 每次直接拿步数即可, 如果获取失败, 则 alert 提示去健康中开启,
 3. 针对是否有步数权限以能否拿到步数数据为准, 因为苹果隐私保护,我们是拿不到读取权限的授权状态的.
 */

import HealthKit

/// 健康数据
extension AuthorityManager {
    func healthStepCount() {
        if HKHealthStore.isHealthDataAvailable() {
            requestStepCountAuth { [weak self] (success, error) in
                if success {
                    self?.getSteps(completion: {[weak self] count, error in
                        if error == nil {
                            self?.authCompletion(true)
                        } else {
                            self?.authCompletion(false)
                            
                            self?.showSettingAlert()
                        }
                    })
                } else {
                    self?.authCompletion(false)
                }
            }
        } else {
            self.authCompletion(false)
        }
    }
    
    private func requestStepCountAuth(completion: @escaping (Bool, Error?) -> Void) {
        if !HKHealthStore.isHealthDataAvailable() {
            completion(false, NSError())
            return
        }
            
        let step = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let allTypes = Set([step])
        
        hasRequestStepCountAuthority = true
        healthStore.requestAuthorization(toShare: nil, read: allTypes ) { (success, error) in
            completion(success, error)
        }
    }
}

@objc public extension AuthorityManager {
    
    /// 是否曾请求过步数授权
    /// - 请求过， 再次查看步数授权则可以直接使用 healthStepCountReadAuthStatus 函数，来判断是否有授权和获取步数
    /// - 没有请求过，如果首次只想看是否有步数权限，不想弹请求坦框， 可以直接 getSteps 函数拿步数， 拿不到则未授权
    @objc private(set) var hasRequestStepCountAuthority: Bool {
        get {
            UserDefaults.standard.value(forKey: "isFirstTimeRequestStepCountAuthority") != nil
        }
        set {
            UserDefaults.standard.set(true, forKey: "isFirstTimeRequestStepCountAuthority")
        }
    }
    
    /// 查询健康步数写入授权, 由于苹果的隐私保护, 无法拿到读权限
    /// - Note: 建议直接使用获取步数方法 - getSteps, 通过是否可以拿到步数来确认是否有读取权限
    /// - Returns: 健康步数写权限的授权状态
    @objc func healthStepCountWriteAuthStatus() -> AuthStatus {
        if HKHealthStore.isHealthDataAvailable() {
            let step = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            let status = healthStore.authorizationStatus(for: step)
            switch status {
            case .notDetermined:
                return .notDetermined
            case .sharingDenied:
                return .denied
            case .sharingAuthorized:
                return .authorized
            @unknown default:
                return .denied
            }
        } else {
            return .denied
        }
    }
    
    /// 获取是否有健康步数的读取权限
    /// - Note 此方法内部会先申请，并通过获取用户的步数来判断是否步数权限， 若不想请求授权，直接使用 getSteps 函数
    /// - Parameter complete: 完成回调
    @objc func healthStepCountReadAuthStatus(complete: @escaping (AuthStatus, Double) -> ()) {
        requestStepCountAuth { [weak self] (success, error) in
            if success {
                self?.getSteps(completion: {count, error in
                    if error != nil {
                        complete(.denied, 0)
                    } else {
                        complete(.authorized, count)
                    }
                })
            } else {
                complete(.denied, 0)
            }
        }
    }
    
    /// 获取步数
    /// - Parameter completion: 拿到的步数信息
    @objc func getSteps(completion: @escaping (Double, Error?) -> Void) {
        if UIDevice.current.userInterfaceIdiom == .pad { // ipadOS 17 之后支持健康框架
            if #available(iOS 17.0, *) {
                // 17 以上继续执行
            } else {
                completion(0, NSError())
                return
            }
        }
        
        guard HKHealthStore.isHealthDataAvailable(), let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            completion(0, NSError())
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result else {
                //print("Failed to fetch steps -- \(error?.localizedDescription)")
                completion(0, error)
                return
            }
            completion(result.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0, nil)
        }
        
        healthStore.execute(query)
    }
}

