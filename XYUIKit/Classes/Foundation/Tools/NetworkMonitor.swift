//
//  NetworkMonitor.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/6/14.
//
/*
 网络状态监听工具
 
 */

import Network

@available(iOS 12.0, *)
public class NetworkMonitor {
    public static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    /// 当前是否是连接状态
    public var isConnected: Bool = false
    /// 当前连接类型
    public var connectionType: NWInterface.InterfaceType?
    /// 网络状态更新回调, 此回调会在主线程执行
    public var netStatusUpdateCallback: ((Bool, NWInterface.InterfaceType?) -> Void)?
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.connectionType = path.availableInterfaces.filter { path.usesInterfaceType($0.type) }.first?.type
            DispatchQueue.main.async {
                self?.netStatusUpdateCallback?(self?.isConnected ?? false, self?.connectionType)
            }
        }
        monitor.start(queue: queue)
    }
}
