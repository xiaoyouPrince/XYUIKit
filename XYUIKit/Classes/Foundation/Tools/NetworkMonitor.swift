//
//  NetworkMonitor.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/6/14.
//
/*
 网络状态监听工具
    iOS 12+ : NetworkMonitor
    iOS 12- : NetworkReachability
 */

/* NetworkMonitor
 ------------------------------ USAGE ----------------------------
 
 struct KeyboardMonitor_InPutBar: View {
 
     @State private var isConnected: Bool = NetworkMonitor.shared.isConnected
     @State private var connectionType = NetworkMonitor.shared.connectionType
     
     var body: some View {
         VStack {
             Text(isConnected ? "Connected" : "Not Connected")
                 .padding()
             Text("connectionType: \(connectionType.debugDescription)")
                 .padding()
             Button("Check Connection") {
                 NetworkMonitor.shared.netStatusUpdateCallback = {
                     isConnected = $0
                     connectionType = $1
                 }
             }
         }
     }
 }
 
 */

import Network

@available(iOS 12.0, *)
public class NetworkMonitor {
    public static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    /// 当前是否是连接状态
    public private(set) var isConnected: Bool = false
    /// 当前连接类型
    public private(set) var connectionType: NWInterface.InterfaceType?
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

/* NetworkReachability
 ------------------------------ USAGE ----------------------------
 
 // create instance variable
 private var networkReachability = NetworkReachability.shared
 
 // start monitor when needed
 networkReachability.startMonitoring()
 
 // add Notification callBack
 NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: nil, queue: .main) { [weak self] _ in
     self?.updateStatusLabel(statusLabel)
 }
 
 // stop monitor when needed
 networkReachability.stopMonitoring()
 */

import SystemConfiguration

public class NetworkReachability {
    public static let shared = NetworkReachability()
    private var reachability: SCNetworkReachability?
    private var isMonitoring = false
    
    public var isConnected: Bool {
        return currentFlags?.contains(.reachable) ?? false
    }
    
    public var connectionType: String {
        guard let flags = currentFlags else { return "Unknown" }
        if flags.contains(.isWWAN) {
            return "Cellular"
        } else if flags.contains(.reachable) {
            return "WiFi"
        } else {
            return "Unknown"
        }
    }
    
    private var currentFlags: SCNetworkReachabilityFlags? {
        guard let reachability = reachability else { return nil }
        var flags = SCNetworkReachabilityFlags()
        if SCNetworkReachabilityGetFlags(reachability, &flags) {
            return flags
        }
        return nil
    }
    
    private init() {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        reachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }
    }
    
    public func startMonitoring() {
        guard !isMonitoring, let reachability = reachability else { return }
        
        var context = SCNetworkReachabilityContext(
            version: 0,
            info: UnsafeMutableRawPointer(Unmanaged<NetworkReachability>.passUnretained(self).toOpaque()),
            retain: nil,
            release: nil,
            copyDescription: nil
        )
        
        let callback: SCNetworkReachabilityCallBack = { (target, flags, info) in
            guard let info = info else { return }
            let instance = Unmanaged<NetworkReachability>.fromOpaque(info).takeUnretainedValue()
            instance.notifyReachabilityChanged()
        }
        
        if SCNetworkReachabilitySetCallback(reachability, callback, &context) {
            if SCNetworkReachabilitySetDispatchQueue(reachability, DispatchQueue.main) {
                isMonitoring = true
            }
        }
    }
    
    public func stopMonitoring() {
        guard isMonitoring, let reachability = reachability else { return }
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        isMonitoring = false
    }
    
    private func notifyReachabilityChanged() {
        NotificationCenter.default.post(name: .reachabilityChanged, object: nil)
    }
    
    deinit {
        stopMonitoring()
    }
}

extension Notification.Name {
    public static let reachabilityChanged = Notification.Name("reachabilityChanged")
}
