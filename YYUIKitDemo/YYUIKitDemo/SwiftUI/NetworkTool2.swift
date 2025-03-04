//
//  NetworkTool2.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2025/3/4.
//

import SwiftUI
import YYUIKit

struct NetworkTool2: View {
    @State var rlt = ""
    
    var body: some View {
        Text("这个是网络请求工具, 计划提供网络请求/下载/上传的能力")
        
        Text("结果 - \n\(rlt)")
            .onAppear{
                // 使用示例
//                getSMSCode(phoneNumber: "00631234567890") { result in
//                    switch result {
//                    case .success(let json):
//                        print("获取短信验证码成功：\(json)")
//                        self.rlt = json.debugDescription
//                        
//                        if let synonyms = json["synonyms"] as? String {
//                            if synonyms == "success" {
//                                //发送成功
//                                print("验证码发送成功")
//                            }else{
//                                //发送失败
//                                print("验证码发送失败")
//                            }
//                        }
//                    case .failure(let error):
//                        print("获取短信验证码失败：\(error.localizedDescription)")
//                        
//                        self.rlt = error.localizedDescription
//                    }
//                }
                
                performRequest(url: "http://8.212.182.12:8767/muscular//cephalopods/removed", method: .post, parameters: ["sequels": "00631234567890"]) { rlt in
                    switch rlt {
                    case .success(let json):
                        print("获取短信验证码成功：\(json)")
                        self.rlt = json.debugDescription
                    case .failure(let error):
                        print("获取短信验证码失败：\(error.localizedDescription)")
                        self.rlt = error.localizedDescription
                    }
                }
            }
        
    }
}

#Preview {
    NetworkTool2()
}


///-------------------------------------
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    // 添加其他需要的 HTTP 方法
}

struct FileData {
    let data: Data
    let filename: String
    let mimeType: String
}

func performRequest(url: String, method: HTTPMethod, headers: [String: String]? = nil, parameters: [String: Any]? = nil, completion: @escaping (Result<[String: Any], Error>) -> Void) {
    // 1. 构建 URL
    guard let url = URL(string: url) else {
        completion(.failure(NSError(domain: "URL Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "无效的 URL"])))
        return
    }
    
    // 2. 构建请求
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    
    // 3. 设置请求头
    if let headers = headers {
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    // 4. 构建请求体 (form-data 或 JSON)
    if let parameters = parameters, method == .post { // 仅对 POST 请求处理参数
        if let contentType = headers?["Content-Type"], contentType.contains("application/json") {
            // JSON
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                completion(.failure(error))
                return
            }
        } else {
            // form-data
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var body = Data()
            for (key, value) in parameters {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                
                if let stringValue = value as? String {
                    body.append("\(stringValue)\r\n".data(using: .utf8)!)
                } else if let intValue = value as? Int {
                    body.append("\(intValue)\r\n".data(using: .utf8)!)
                } else if let doubleValue = value as? Double {
                    body.append("\(doubleValue)\r\n".data(using: .utf8)!)
                } else if let boolValue = value as? Bool {
                    body.append("\(boolValue)\r\n".data(using: .utf8)!)
                } else if let arrayValue = value as? [Any] {
                    // 将数组转换为 JSON 字符串
                    if let jsonData = try? JSONSerialization.data(withJSONObject: arrayValue, options: []),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        body.append("\(jsonString)\r\n".data(using: .utf8)!)
                    }
                } else if let dictValue = value as? [String: Any] {
                    // 将字典转换为 JSON 字符串
                    if let jsonData = try? JSONSerialization.data(withJSONObject: dictValue, options: []),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        body.append("\(jsonString)\r\n".data(using: .utf8)!)
                    }
                } else if let fileData = value as? FileData {
                    // 处理文件上传
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileData.filename)\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: \(fileData.mimeType)\r\n\r\n".data(using: .utf8)!)
                    body.append(fileData.data)
                    body.append("\r\n".data(using: .utf8)!)
                }
            }
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            request.httpBody = body
        }
    }
    
    // 5. 创建 URLSession
    let session = URLSession.shared
    
    // 6. 创建 Data Task
    let task = session.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            completion(.failure(NSError(domain: "HTTP Error", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "无效的响应"])))
            return
        }
        
        guard let data = data else {
            completion(.failure(NSError(domain: "Data Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "没有数据"])))
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                completion(.success(json))
            } else {
                completion(.failure(NSError(domain: "JSON Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "无法解析 JSON"])))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    // 7. 启动 Task
    task.resume()
}

/*
// 使用示例
let parameters: [String: Any] = [
    "username": "JohnDoe",
    "age": 30,
    "avatar": FileData(data: Data(), filename: "avatar.png", mimeType: "image/png") // 替换为实际文件数据
]

performRequest(url: "你的URL", method: .post, parameters: parameters) { result in
    // 处理结果
}

*/
