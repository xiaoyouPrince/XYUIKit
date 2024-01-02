//
//  XYNetTool.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2022/4/26.
//

/*
 一个简单的 网络工具，用于开发过程中的网络请求/网络连接状态判断
 */

import UIKit
public typealias NetTool = XYNetTool
public struct XYNetTool {
    private init () {}
    
    public typealias AnyJsonCallback = ([String: Any])->()
    public typealias DataCallback = (Data)->()
    public typealias ErrorCallback = (_ errMsg: String)->()
    
    public static func get(url: URL,
                           paramters: [String: Any],
                           headers: [String: String]?,
                           success: @escaping AnyJsonCallback,
                           failure: @escaping ErrorCallback) {
        request(url: url, method: .GET, paramters: paramters, headers: headers, success: success, failure: failure)
    }
    public static func post(url: URL,
                            paramters: [String: Any],
                            headers: [String: String]?,
                            success: @escaping AnyJsonCallback,
                            failure: @escaping ErrorCallback) {
        request(url: url, method: .POST, paramters: paramters, headers: headers, success: success, failure: failure)
    }
    public static func download(url: URL,
                                paramters: [String: Any],
                                headers: [String: String]?,
                                success: @escaping DataCallback,
                                failure: @escaping ErrorCallback) {
        request(url: url, method: .POST, paramters: paramters, headers: headers, success: success, failure: failure)
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
        session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // 网络异常
                DispatchQueue.main.async {
                    failure(error!.localizedDescription)
                }
                return;
            }
            
            // Json 格式处理
            if let success = success as? AnyJsonCallback {
                if let data = data, let resultJson = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed), let dict = resultJson as? [String: Any] {
                    if let code = dict["code"] as? Int, code == 200 {
                        DispatchQueue.main.async {
                            if let data = dict["data"] as? [String : Any] {
                                success(data)
                            }else{
                                success([:])
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            failure(dict["message"] as? String ?? "服务异常,返回非 200")
                            print(dict)
                        }
                    }
                }else{
                    // 非JSON格式返回
                    success([:])
                }
            }
            
            // 下载文件类型
            if let success = success as? DataCallback {
                success(data ?? .init())
            }
            
        }.resume()
    }
}
