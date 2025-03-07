//
//  AppFunctionView.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/2/26.
//

import SwiftUI
import YYUIKit

struct AppFunctionView: View {
    
    @State var image: UIImage?
    @State var imageDataBytes: String?
    
    var body: some View {
        
        List {
            
            Text("本页面展示了 YYUIkit 中提供的便捷 App 功能的使用, 下面按钮分别展示具体功能")
            
            Section {
                Button("选择联系人 - iOS 9+") {
                    let vc = UIHostingController(rootView: ContentView())
                    UIViewController.currentVisibleVC.nav_push(vc, animated: true)
                }
                
            } header: {
                Text("1. 颜色选择器")
            }
            
            Section {
                Button("颜色选择器 - iOS 14+") {
                    if #available(iOS 14.0, *) {
                        AppUtils.chooseColor { color in
                            Toast.make(color.toHexString())
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
            } header: {
                Text("1. 颜色选择器")
            }
            
            Section {
                let beiziImageUrl = "https://stage-cdn.fun-widget.haoqimiao.net/resource/wallpaper/20241209/original_1865968700152430592.jpeg"
                
                Button("无损保存图片到相册 - iOS 8+") {
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: URL(string: beiziImageUrl)!), let image = UIImage(data: data) {
                            self.image = image
                            self.imageDataBytes = "\(data.count) Bytes"
                            AppUtils.saveImageToPhotosAlbum(imageData: data) { success, errMsg in
                                if success {
                                    Toast.make("保存成功")
                                } else {
                                    Toast.make( errMsg ?? "保存失败")
                                }
                            }
                        }
                    }
                }
                
                Button("保存图片到相册(系统会自动优化图片，大小可能会变) - iOS 2+") {
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: URL(string: beiziImageUrl)!), let image = UIImage(data: data) {
                            self.image = image
                            self.imageDataBytes = "\(data.count) Bytes"
                            AppUtils.saveImageToPhotosAlbum(image: image) { success, errMsg in
                                if success {
                                    Toast.make("保存成功")
                                } else {
                                    Toast.make( errMsg ?? "保存失败")
                                }
                            }
                        }
                    }
                }
                
                if let image, let imageDataBytes {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: .width - 40, height: 250)
                    
                    Text("图片大小：\(imageDataBytes)")
                }
                
            } header: {
                Text("2. 图片保存到相册")
            }
            
        }
    }
}

#Preview {
    AppFunctionView()
}
