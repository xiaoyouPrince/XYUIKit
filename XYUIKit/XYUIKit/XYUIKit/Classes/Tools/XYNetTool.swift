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
open class XYNetTool: NSObject {
    
    public enum RequestType: String {
        case GET, POST
    }
    
    public static var shared = XYNetTool()
    public static func get(url: URL,
                            paramters: [String: Any],
                            headers: [String: String]?,
                            success: @escaping ([String: Any])->(),
                            failure: @escaping (String)->()) {
        request(url: url, method: .GET, paramters: paramters, headers: headers, success: success, failure: failure)
    }
    public static func post(url: URL,
                            paramters: [String: Any],
                            headers: [String: String]?,
                            success: @escaping ([String: Any])->(),
                            failure: @escaping (String)->()) {
        request(url: url, method: .POST, paramters: paramters, headers: headers, success: success, failure: failure)
    }
    
    public static func request(url: URL,
                               method: RequestType,
                           paramters: [String: Any],
                           headers: [String: String]?,
                           success: @escaping ([String: Any])->(),
                           failure: @escaping (String)->()){
        
        let request = NSMutableURLRequest(url: url)
        request.timeoutInterval = 10
        request.httpMethod = method.rawValue
        
        if let data = try? JSONSerialization.data(withJSONObject: paramters, options: .fragmentsAllowed) {
            request.httpBody = data
        }
       
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: shared, delegateQueue: OperationQueue.main)
        session.dataTask(with: request as URLRequest) { data, response, error in
            
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
            }
            
            //if let response = response {
            //    Toast.make(response.description)
            //}
            
            if error != nil { // 网络异常
                DispatchQueue.main.async {
                    failure("网络异常")
                }
            }
            
        }.resume()
    }

}

extension XYNetTool: URLSessionDelegate {
    
}
