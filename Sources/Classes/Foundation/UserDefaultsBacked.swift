//
//  UserDefaultsBacked.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/12/18.
//

/*
 将属性存在到 UserDefaults 中
 
 -------------- Usage ------------
 struct AppSettings {
     @UserDefaultsBacked(key: "isDarkModeEnabled", defaultValue: false)
     static var isDarkModeEnabled: Bool
     
     @UserDefaultsBacked(key: "username", defaultValue: "Guest")
     static var username: String
     
     @UserDefaultsBacked(key: "loginCount", defaultValue: 0)
     static var loginCount: Int
 }
 */


import Foundation

@propertyWrapper public
struct UserDefaultsBacked<Value> {
    private let key: String
    private let defaultValue: Value
    private let storage: UserDefaults
    
    public init(key: String, defaultValue: Value, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
    
    public var wrappedValue: Value {
        get {
            storage.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
}
