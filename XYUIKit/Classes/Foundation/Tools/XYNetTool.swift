//
//  XYNetTool.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2022/4/26.
//

/*
 一个简单的 网络工具，用于开发过程中的网络请求/网络连接状态判断
 */

import Foundation
public typealias NetTool = XYNetTool
public struct XYNetTool {
    private init () {}
    
    public typealias AnyJsonCallback = ([String: Any])->()
    public typealias DataCallback = (Data)->()
    public typealias ErrorCallback = (_ errMsg: String)->()
    public typealias DownloadDataCallback = (_ filePath: URL?, _ error: Error?)->()
    
    /// GET 方式请求获取 JSON 数据
    /// - Parameters:
    ///   - url: 网络地址
    ///   - headers: 请求头
    ///   - success: 成功回调, 返回 json dictionary
    ///   - failure: 失败回调
    public static func get(url: URL,
                           paramters: [String: Any],
                           headers: [String: String]?,
                           success: @escaping AnyJsonCallback,
                           failure: @escaping ErrorCallback) {
        request(url: url, method: .GET, paramters: paramters, headers: headers, success: success, failure: failure)
    }
    
    /// POST 方式请求获取 JSON 数据
    /// - Parameters:
    ///   - url: 网络地址
    ///   - paramters: 请求参数
    ///   - headers: 请求头
    ///   - success: 成功回调, 返回 json dictionary
    ///   - failure: 失败回调
    public static func post(url: URL,
                            paramters: [String: Any],
                            headers: [String: String]?,
                            success: @escaping AnyJsonCallback,
                            failure: @escaping ErrorCallback) {
        request(url: url, method: .POST, paramters: paramters, headers: headers, success: success, failure: failure)
    }
    
    /// 下载数据, 直接返回网络接口拿到的 Data 数据
    /// - Parameters:
    ///   - url: 网络地址
    ///   - paramters: 请求参数
    ///   - headers: 请求头
    ///   - success: 成功回调, 参数为网络拿到的 Data 数据
    ///   - failure: 失败回调
    public static func download(url: URL,
                                paramters: [String: Any],
                                headers: [String: String]?,
                                success: @escaping DataCallback,
                                failure: @escaping ErrorCallback) {
        request(url: url, method: .POST, paramters: paramters, headers: headers, success: success, failure: failure)
    }
    
    /// 下载文件到指定 URL 地址(GET)
    /// - Parameters:
    ///   - url: 网络地址
    ///   - paramters: 请求参数
    ///   - headers: 请求头
    ///   - saveToUrl: 文件指定要存储的 fileURL
    ///   - timeoutInterval: 业务网络超时时间，默认为nil: 10s 连接超时时间，若指定超时时间则按指定值设置连接超时时间和整体完成超时时间，如在指定时间内没有完成整个请求（连接+数据传输）则按超时处理，执行 failure 回调
    ///   - completion: 完成回调, 参数为当前文件存储地址(成功的情况下为saveToUrl), 或者失败后的 error 信息
    public static func download(url: URL,
                                paramters: [String: Any],
                                headers: [String: String]?,
                                saveToUrl: URL,
                                timeoutInterval: TimeInterval? = nil,
                                completion: @escaping DownloadDataCallback) {
        request(url: url, method: .GET, paramters: paramters, headers: headers, saveToUrl: saveToUrl, timeoutInterval: timeoutInterval, completion: completion)
    }
    
}


private extension XYNetTool {
    enum RequestType: String {
        case GET, POST
    }
    
    /*
     目前支持:
     post / get 返回格式: ([String: Any])->()
     download 返回格式 (Data)->()
     */
    
    static func request(url: URL,
                        method: RequestType,
                        paramters: [String: Any],
                        headers: [String: String]?,
                        success: Any,
                        failure: @escaping (String)->()){
        DispatchQueue.global().async {
            let (request, session) = getRequestAndSession(url: url, method: method, paramters: paramters, headers: headers)
            
            session.dataTask(with: request) { data, response, error in
                if error != nil { // error: 网络异常, timeout
                    failure(error!.localizedDescription)
                    return;
                }
                
                // JSON 格式处理
                if let success = success as? AnyJsonCallback {
                    if let data = data, let resultJson = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed), let dict = resultJson as? [String: Any] {
                        success(dict)
                    }else{
                        failure(error?.localizedDescription ?? "")
                    }
                }
                
                // 下载数据类型
                if let success = success as? DataCallback {
                    success(data ?? .init())
                }
            }.resume()
        }
    }
    
    static func request(url: URL,
                        method: RequestType,
                        paramters: [String: Any],
                        headers: [String: String]?,
                        saveToUrl: URL,
                        timeoutInterval: TimeInterval? = nil,
                        completion: @escaping DownloadDataCallback) {
        
        var hasTimeOut: Bool = false
        var hasRequestComplete: Bool = false
        if let timeoutInterval = timeoutInterval {
            let timeoutInterval: TimeInterval = timeoutInterval
            DispatchQueue.main.asyncAfter(deadline: .now() + timeoutInterval) {
                if !hasRequestComplete {
                    hasTimeOut = true
                    completion(nil, NSError(domain: "YYUIKit.NetTool", code: -1001, userInfo: [NSLocalizedFailureReasonErrorKey: "timeout"]))
                }
            }
        }
        
        
        DispatchQueue.global().async {
            let (request, session) = getRequestAndSession(url: url, method: method, paramters: paramters, headers: headers)
            
            session.downloadTask(with: request) { tmpFileUrl, urlResponse, error in
                if hasTimeOut { return }
                
                hasRequestComplete = true
                if let tmpFileUrl = tmpFileUrl {
                    do {
                        try FileManager.default.moveItem(at: tmpFileUrl, to: saveToUrl)
                        completion(saveToUrl, nil)
                    }catch{
                        print("NetTool download task did fail to move file with error: \(error.localizedDescription)")
                        completion(nil, error)
                    }
                } else {
                    completion(nil, error)
                }
            }.resume()
        }
    }
    
    
    static func getRequestAndSession(url: URL,
                                     method: RequestType,
                                     paramters: [String: Any],
                                     headers: [String: String]?) -> (URLRequest, URLSession){
        let request = NSMutableURLRequest(url: url)
        request.timeoutInterval = 10
        request.httpMethod = method.rawValue
        
        if method == .GET {
            if paramters.isEmpty == false {
                var pStr = "?"
                paramters.forEach { (k, v) in
                    pStr.append("\(k)=\(v)&")
                }
                let pStrResult = String(pStr.dropLast())
                request.url = URL(string: url.absoluteString + pStrResult)
            }
        }else
        if method == .POST {
            if let data = try? JSONSerialization.data(withJSONObject: paramters, options: .fragmentsAllowed) {
                request.httpBody = data
            }
        }
        
        
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        
        return (request as URLRequest, session)
    }
}
