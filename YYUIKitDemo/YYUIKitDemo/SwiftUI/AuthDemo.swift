//
//  AuthDemo.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/7/22.
//

import SwiftUI
import YYUIKit
import Modelable

struct AuthDemo: View {
    
    @State
    private var locStatus = AuthorityManager.shared.locationAuthStatus() == .authorized
    
    @State
    private var bluetoothStatus = AuthorityManager.shared.bluetoothAuthStatus() == .authorized
    
    @State
    private var notificationStatus = false // notification status 需要异步获取
    
    @State
    private var activityStatus = false // AuthorityManager.shared.activityAuthStatus() == .authorized
    
    @State
    private var healthStatus = false // AuthorityManager.shared.healthAuthStatus() == .authorized
    @State
    private var healthStepCount: Double = 0
    
    
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
        
        if #available(iOS 16.1, *) {
            Button {
                AuthorityManager.shared.request(auth: .activity, scene: "B") { completion in
                    print(completion)
                    self.activityStatus = completion
                }
                
            } label: {
                VStack {
                    ZStack {
                        Color(UIColor.random)
                        Text("实时活动开启状态(iOS 16.1+)")
                    }.frame(width: .width, height: 44)
                }
            }
            Text("实时活动权限 - \(activityStatus.stringValue)")
        }
        
        Button {
            AuthorityManager.shared.request(auth: .healthStepCount, scene: "B") { completion in
                print(completion)
                self.healthStatus = completion
                AuthorityManager.shared.getSteps { count, error in
                    if error == nil {
                        self.healthStepCount = count
                    } else {
                        Toast.make("获取步数出错 - 无权限")
                    }
                }
            }
            
        } label: {
            VStack {
                ZStack {
                    Color(UIColor.random)
                    Text("请求健康步数权限")
                }.frame(width: .width, height: 44)
            }
        }
        Text("健康步数权限 - \(healthStatus.stringValue)")
        Text("当前步数 - \(healthStepCount)")

        Spacer()
            .onAppear {
                // update notification status
                AuthorityManager.shared.notificationAuthStatus({ status in
                    notificationStatus = status == .authorized
                })
                
                // health
                AuthorityManager.shared.healthStepCountReadAuthStatus { status, count in
                    self.healthStatus = status == .authorized
                    AuthorityManager.shared.getSteps { count, error in
                        if error == nil {
                            self.healthStepCount = count
                        } else {
                            Toast.make("获取步数出错 - 无权限")
                        }
                    }
                }
                
                
                #if DEBUG
                let ab = ["name": "DEBUG", "age": 19]
                if let model = Info.mapping(jsonObject: ab) {
                    print(model)
                }
                
                #else
                let ab = ["name": "RELEASE", "age": 19]
                if let model = Info.mapping(jsonObject: ab) {
                    print(model)
                }
                #endif
                
            }
    }
}


struct Info: Model {
    var name: String?
    var age: Int?
}

#Preview {
    AuthDemo()
}


//import ActivityKit
//
//struct ActivityHelper {
//    
//    struct MyActivityAttributes: ActivityAttributes {
//        struct ContentState: Codable, Hashable {
//            var value: Int
//        }
//        
//        var name: String
//    }
//    
//    func startLiveActivity() {
//        if #available(iOS 16.1, *) {
//            let attributes = MyActivityAttributes(name: "Example Activity")
//            let initialContentState = MyActivityAttributes.ContentState(value: 0)
//            do {
//                let activity = try Activity<MyActivityAttributes>.request(attributes: attributes, contentState: initialContentState, pushType: nil)
//                print("Live activity started: \(activity.id)")
//            } catch {
//                print("Failed to start live activity: \(error)")
//            }
//        } else {
//            print("ActivityKit is not available on this iOS version.")
//        }
//    }
//    
//    func updateLiveActivity() {
//        if #available(iOS 16.1, *) {
//            let contentState = MyActivityAttributes.ContentState(value: 1)
//            Task {
//                for activity in Activity<MyActivityAttributes>.activities {
//                    await activity.update(using: contentState)
//                    print("Live activity updated: \(activity.id)")
//                }
//            }
//        }
//    }
//    
//    func endLiveActivity() {
//        if #available(iOS 16.1, *) {
//            Task {
//                for activity in Activity<MyActivityAttributes>.activities {
//                    await activity.end(dismissalPolicy: .immediate)
//                    print("Live activity ended: \(activity.id)")
//                }
//            }
//        }
//    }
//}


