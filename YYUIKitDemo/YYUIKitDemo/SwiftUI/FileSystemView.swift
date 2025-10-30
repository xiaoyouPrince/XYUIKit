//
//  FileSystemView.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/2/24.
//

import SwiftUI
import YYUIKit

struct FileSystemView: View {
    
    let sandboxPath = FileSystem.sandBoxPath()
    let mainBundlePath = FileSystem.mainBundlePath()
    let documentPath = FileSystem.documentPath()
    let cachePath = FileSystem.cachePath()
    let libraryPath = FileSystem.libraryPath()
    let tempPath = FileSystem.tempPath()
    
    @State var header: Bool = false
    
    func setHeader() {
        header.toggle()
    }
    
    var body: some View {
        
        if header {
            let fileName = "\(Date().string(withFormatter: "yyyy-MM-dd"))-example"
            Text("文件名: \(fileName)")
                .onAppear {
                    if let path = writeTextToDocuments(fileName: fileName, content: "Hello, Documents! I am the file created by you today!") {
                        print("文件路径: \(path)")
                    }
                }
        }
        
        Button("点我快速,在 Document 文件夹下创建一个文件") {
            setHeader()
        }
        
        List {
            
            Text("本页面展示了 YYUIkit 中文件系统 FileSystem 的使用, 下面按钮分别展示了查看不同目录的Demo")
            
            Section {
                Button("沙盒目录 sandbox") {
                    AppUtils.openFolder(sandboxPath)
                }
                
                Button("mainBundle") {
                    AppUtils.openFolder(mainBundlePath)
                }
                
                Button("文档目录 document") {
                    AppUtils.openFolder(documentPath)
                }
                
                Button("缓存目录 cache") {
                    AppUtils.openFolder(cachePath)
                }
                
                Button("资源目录 Library") {
                    AppUtils.openFolder(libraryPath)
                }
                
                Button("临时目录 temp") {
                    AppUtils.openFolder(tempPath)
                }
            } header: {
                Text("1. Present 弹出效果")
            }
            
            Section {
                Button("沙盒目录 sandbox") {
                    AppUtils.openFolder(sandboxPath, withPush: UIViewController.currentVisibleVC.navigationController!)
                }
                
                Button("mainBundle") {
                    AppUtils.openFolder(mainBundlePath, withPush: UIViewController.currentVisibleVC.navigationController!)
                }
                
                Button("文档目录 document") {
                    AppUtils.openFolder(documentPath, withPush: UIViewController.currentVisibleVC.navigationController!)
                }
                
                Button("缓存目录 cache") {
                    AppUtils.openFolder(cachePath, withPush: UIViewController.currentVisibleVC.navigationController!)
                }
                
                Button("资源目录 Library") {
                    AppUtils.openFolder(libraryPath, withPush: UIViewController.currentVisibleVC.navigationController!)
                }
                
                Button("临时目录 temp") {
                    AppUtils.openFolder(tempPath, withPush: UIViewController.currentVisibleVC.navigationController!)
                }
            } header: {
                Text("2. Push 弹出效果")
            }
        }
    }
}

#Preview {
    FileSystemView()
}

import Foundation

/// 写入文本文件到 Documents 目录
/// - Parameters:
///   - fileName: 文件名（可不含扩展名）
///   - content: 要写入的字符串内容
/// - Returns: 完整文件路径（若失败返回 nil）
@discardableResult
func writeTextToDocuments(fileName: String, content: String) -> String? {
    // 获取 Documents 目录路径
    guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }
    
    // 确保文件名带 .txt 后缀
    let finalName = fileName.hasSuffix(".txt") ? fileName : fileName + ".txt"
    let fileURL = documentsURL.appendingPathComponent(finalName)
    
    do {
        // 写入 UTF-8 文本
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        print("✅ 写入成功：\(fileURL.path)")
        return fileURL.path
    } catch {
        print("❌ 写入失败：\(error)")
        return nil
    }
}
