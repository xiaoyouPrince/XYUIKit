//
//  XYFileManager.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2023/7/4.
//

/**
 一个简单的文件管理器工具 - CURD
 1. 写文件
 2. 更新文件
 3. 读取文件
 4. 删除文件
 
 参数需要自己指定路径, 内部自动根据入参路径进行拼接
 此工具假设存储的是符合 Codable 协议的数据模型, 读取出的内容是模型数组
 
 - 此文件首次运行在 Cheater App 微信单聊数据列表中
 */

import Foundation

public struct XYFileManager {
    
    /// 根路径 url
    public static let rootURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    /// document 文档目录 pathString
    public static let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    
    /// 创建文件
    /// - Parameter pathOrFileName: 传入文件路径或者文件名 egg: tools/a.tool 或者 a.tool
    /// - Returns: 默认返回true, 当出现异常返回 false
    @discardableResult
    public static func creatFile(with pathOrFileName: String) -> Bool {
        guard let url = rootURL?.appendingPathComponent(pathOrFileName) else { return false }
        
        if FileManager.default.fileExists(atPath: url.path ) == false { // 文件不存在,先创建
            FileManager.default.createFile(atPath: url.absoluteString, contents: nil)
        }
        
        // 已经存在,直接返回
        return true
    }
    
    /// 读取文件中保存的模型
    /// - Parameter pathOrFileName: 传入文件路径或者文件名 egg: tools/a.tool 或者 a.tool
    /// - Returns: 返回指定的文件模型数组
    public static func readFile<Model: Codable>(with pathOrFileName: String) -> [Model] {
        guard let url = rootURL?.appendingPathComponent(pathOrFileName) else { return [] }
        
        do {
            let data = try Data(contentsOf: url) // 使用 JSONDecoder 解码数据为 Model 对象
            let decoder = JSONDecoder()
            let models = try decoder.decode([Model].self, from: data)
            return models
        } catch {
            print("Failed to read data from file: \(error)")
        }
        
        return []
    }
    
    /// 增加文件中保存的模型
    /// - Parameter pathOrFileName: 传入文件路径或者文件名 egg: tools/a.tool 或者 a.tool
    /// - Returns: 返回指定的文件模型数组
    @discardableResult
    public static func appendFile<Model: Codable>(with pathOrFileName: String, model: Model) -> [Model] {
        guard (rootURL?.appendingPathComponent(pathOrFileName)) != nil else { return [] }
        
        var origin: [Model] = readFile(with: pathOrFileName)
        origin.append(model)
        
        writeFile(with: pathOrFileName, models: origin)
        return origin
    }
    
    /// 写文件, 将指定内容写入文件
    /// - Parameter pathOrFileName: 传入文件路径或者文件名 egg: tools/a.tool 或者 a.tool
    /// - Returns: 返回指定的文件模型数组
    @discardableResult
    public static func writeFile<Model: Codable>(with pathOrFileName: String, models: [Model]) -> [Model] {
        guard let url = rootURL?.appendingPathComponent(pathOrFileName) else { return [] }
        
        let origin = models
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted  // 可选：设置输出格式更易读
        do {
            let data = try encoder.encode(origin) // 将数据写入文件
            try data.write(to: url)
        } catch {
            print("Failed to store contact data: \(error)")
        }
        
        return origin
    }
    
}

extension XYFileManager {
    
    /// Returns the container directory associated with the specified security application group ID.
    /// - Parameter groupIdentifier: app group id
    /// - Returns: Returns the container directory associated with the specified security application group ID.
    public static func containerURL(for groupIdentifier: String) -> URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
    }
    
    /// 校验文件URL. 如果中间path存在空路径,则创建文件夹
    /// - 例如: 随机指定一个文件URL, append 几层文件夹之后, 通过此方法将中间不存在的路径创建好, 但不创建最后一层
    /// - Parameter url: 文件URL
    public static func validateURL(url: URL) {
        if !url.isFileURL { return }
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) { return }
        
        var currentFileURL = URL(string: "file://")!
        for path in url.pathComponents {
            if path == url.pathComponents.last { break }
            
            currentFileURL = currentFileURL.appendingPathComponent(path)
            if fileManager.fileExists(atPath: currentFileURL.path) {
                //print("文件路径存在: \(currentFileURL)")
            }else{
                // print("文件路径不存在: \(currentFileURL)")
                do {
                    try fileManager.createDirectory(atPath: currentFileURL.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    /// 移除指定目录下的所有子内容, 包含文件夹/子文件
    /// - Parameter filePath: 指定文件 path
    public static func removeItems(for filePath: String) {
        let subPaths = showFileAndPath(filePath)
        for path in subPaths.reversed() {
            do {
                try FileManager.default.removeItem(atPath: filePath + "/" + path)
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    /// 展示指定目录下所有的子文件夹/目录
    /// - Parameter forPath: 指定的文件目录
    /// - Returns: 当前文件夹下面所有子文件目录
    @discardableResult
    public static func showFileAndPath(_ forPath: String = documentPath ?? "") -> [String] {
        if forPath.isEmpty { return [] }
        
        let subPaths = FileManager.default.subpaths(atPath: forPath) ?? []
        print("------ Starting show file path for: ------- \n", forPath)
        subPaths.forEach { subPath in
            print(subPath)
        }
        print("------ end ----- \n")
        return subPaths
    }
}

