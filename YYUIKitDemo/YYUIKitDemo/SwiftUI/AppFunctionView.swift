//
//  AppFunctionView.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/2/26.
//

import SwiftUI
import YYUIKit

struct AppFunctionView: View {
    
    var body: some View {
        
        List {
            
            Text("本页面展示了 YYUIkit 中提供的便捷 App 功能的使用, 下面按钮分别展示具体功能")
            
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
                
//                Button("mainBundle") { // for iPad popover View
//                    AppUtils.openFolder(mainBundlePath)
//                }
                
            } header: {
                Text("1. 颜色选择器")
            }
            
        }
    }
}

#Preview {
    AppFunctionView()
}
