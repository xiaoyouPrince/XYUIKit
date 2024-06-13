//
//  KeyboardMonitor&InPutBar.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/6/13.
//

import SwiftUI
import YYUIKit

struct KeyboardMonitor_InPutBar: View {
    
    @State var text: String = ""
    var keyboardMonitor: KeyboardMonitor! = .init()
    var toolBar: EmptyView = .init()
    
    var body: some View {
        
        
        ScrollView(.vertical) {
            Text("本页面会创建一个键盘监听和输入框")
            
            TextField("请输入内容", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding()
                .foregroundColor(.green)
            
            
        }.onAppear {
            // 设置键盘状态回调
            keyboardMonitor?.keyboardWillShow = { startFrame, endFrame, duration in
                print("Keyboard will show from frame: \(startFrame) to frame: \(endFrame) with duration: \(duration)")
            }
            
            keyboardMonitor?.keyboardDidShow = { startFrame, endFrame, duration in
                print("Keyboard did show from frame: \(startFrame) to frame: \(endFrame) with duration: \(duration)")
            }
            
            keyboardMonitor?.keyboardWillHide = { startFrame, endFrame, duration in
                print("Keyboard will hide from frame: \(startFrame) to frame: \(endFrame) with duration: \(duration)")
            }
            
            keyboardMonitor?.keyboardDidHide = { startFrame, endFrame, duration in
                print("Keyboard did hide from frame: \(startFrame) to frame: \(endFrame) with duration: \(duration)")
            }
            
        }
        
    }
}

#Preview {
    KeyboardMonitor_InPutBar()
}
