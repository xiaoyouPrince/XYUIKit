//
//  AuthDemo.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/7/22.
//

import SwiftUI
import YYUIKit

struct AuthDemo: View {
    
    @State
    private var locStatus = AuthorityManager.shared.locationAuthStatus() == .authorized
    
    @State
    private var bluetoothStatus = AuthorityManager.shared.bluetoothAuthStatus() == .authorized
    
    @State
    private var notificationStatus = false // notification status 需要异步获取
    
    
    var body: some View {
        Text("AppName: \(UIApplication.appName)")
        Text("这个页面主要展示权限授权示例")
        
        Button {
            AuthorityManager.shared.request(auth: .location, scene: "B") { completion in
                print(completion)
                self.locStatus = completion
            }
        } label: {
            ZStack {
                Color(UIColor.random)
                Text("请求位置权限")
            }.frame(width: .width, height: 44)
        }
        Text("定位权限 - \(locStatus.stringValue)")
        
        Button {
            AuthorityManager.shared.request(auth: .bluetooth, scene: "B") { completion in
                print(completion)
                self.bluetoothStatus = completion
            }
        } label: {
            ZStack {
                Color(UIColor.random)
                Text("请求蓝牙权限")
            }.frame(width: .width, height: 44)
        }
        Text("蓝牙权限 - \(bluetoothStatus.stringValue)")
        
        Button {
            AuthorityManager.shared.request(auth: .notification, scene: "B") { completion in
                print(completion)
                self.notificationStatus = completion
            }
        } label: {
            ZStack {
                Color(UIColor.random)
                Text("请求通知权限")
            }.frame(width: .width, height: 44)
        }
        Text("通知权限 - \(notificationStatus.stringValue)")

        Spacer()
            .onAppear {
                // update notification status
                AuthorityManager.shared.notificationAuthStatus({ status in
                    notificationStatus = status == .authorized
                })
            }
    }
}

#Preview {
    AuthDemo()
}
