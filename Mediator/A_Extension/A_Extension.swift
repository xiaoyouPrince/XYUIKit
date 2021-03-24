//
//  A_Extension.swift
//  A_Extension
//
//  Created by casa on 2018/8/23.
//  Copyright © 2018年 casa. All rights reserved.
//

//import CTMediator

public extension CTMediator {
    
    // 纯本地
    @objc public func A_showSwift_local(callback:@escaping (String) -> Void) -> UIViewController? {
        let params = [
            "callback":callback,
            kCTMediatorParamsKeySwiftTargetModuleName:""
            ] as [AnyHashable : Any]
        if let viewController = self.performTarget("A", action: "Extension_ViewController", params: params, shouldCacheTarget: false) as? UIViewController {
            return viewController
        }
        return nil
    }
    
    // 本地模块
    @objc public func A_showSwift(callback:@escaping (String) -> Void) -> UIViewController? {
        let params = [
            "callback":callback,
            kCTMediatorParamsKeySwiftTargetModuleName:"A_swift"
            ] as [AnyHashable : Any]
        if let viewController = self.performTarget("A", action: "Extension_ViewController", params: params, shouldCacheTarget: false) as? UIViewController {
            return viewController
        }
        return nil
    }
    
    @objc public func A_showObjc(callback:@escaping (String) -> Void) -> UIViewController? {
        let callbackBlock = callback as @convention(block) (String) -> Void
        let callbackBlockObject = unsafeBitCast(callbackBlock, to: AnyObject.self)
        let params = ["callback":callbackBlockObject] as [AnyHashable:Any]
        if let viewController = self.performTarget("A", action: "Extension_ViewController", params: params, shouldCacheTarget: false) as? UIViewController {
            return viewController
        }
        return nil
    }
}
