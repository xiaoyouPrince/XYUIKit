//
//  NetWorkTool.swift
//  YYUIKitDemo
//
//  Created by will on 2024/6/24.
//

import SwiftUI
import YYUIKit
import Network

struct NetWorkTool: View {
    
    // iOS 12 之后的工具
    @State private var isConnected: Bool = NetworkMonitor.shared.isConnected
    @State private var connectionType = NetworkMonitor.shared.connectionType
    
    
    // iOS 12 之前可以使用的工具
    private var networkReachability = NetworkReachability.shared
    
    @State var bgColor: Color = .yellow
    
    var body: some View {
        
        ZStack {
            bgColor
            VStack {
                Text("这是一个网络工具的Demo")
                Text("需要真机测试")
                
                Divider()
                
                // iOS 12 之后
                

                Button("iOS 12之后 NetWork 框架监听网络状态") {
                    
                }
                Text(isConnected ? "Connected" : "Not Connected")
                    .padding()
                Text("connectionType: \(string(with: connectionType))")
                    .padding()
                
                Divider()
                
                // iOS 12 之前
                Button("iOS 12之前 SystemConfiguration 框架监听网络状态") {
                    if networkReachability.isConnected {
                        bgColor = .green
                    } else {
                        bgColor = .yellow
                    }
                }
                Text(networkReachability.isConnected ? "Connected" : "Not Connected")
                    .padding()
                Text("connectionType: \(networkReachability.connectionType)")
                    .padding()
                
                
                Spacer()
            }
        }.onAppear {
            // 12 +
            NetworkMonitor.shared.netStatusUpdateCallback = {
                isConnected = $0
                connectionType = $1
            }
            
            
            // 12 -
            NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: nil, queue: .main) { _ in
                if networkReachability.isConnected {
                    bgColor = .green
                } else {
                    bgColor = .yellow
                }
            }
            networkReachability.startMonitoring()
        }.onDisappear {
            networkReachability.stopMonitoring()
        }
    }
    
    func string(with type: NWInterface.InterfaceType?) -> String {
        if let type = type {
            switch type {
            case .other:
                return "other"
            case .wifi:
                return "wifi"
            case .cellular:
                return "cellular"
            case .wiredEthernet:
                return "wiredEthernet"
            case .loopback:
                return "loopback"
            @unknown default:
                return "Unknown"
            }
        } else {
            return "Unknown"
        }
    }
}

#Preview {
    NetWorkTool()
}
