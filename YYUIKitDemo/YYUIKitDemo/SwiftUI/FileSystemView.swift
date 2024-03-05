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
            Text("------")
        }
        
        Button("header") {
//            header.toggle()
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
