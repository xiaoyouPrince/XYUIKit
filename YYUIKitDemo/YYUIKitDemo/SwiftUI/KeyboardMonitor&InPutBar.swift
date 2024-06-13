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
            Text("本页面会创建一个键盘监听和输入框")
            
            
            Text("本页面会创建一个键盘监听和输入框")
            
            
            Text("本页面会创建一个键盘监听和输入框")
            Text("本页面会创建一个键盘监听和输入框")
            Text("本页面会创建一个键盘监听和输入框")
            Text("本页面会创建一个键盘监听和输入框")
            Text("本页面会创建一个键盘监听和输入框")
            Text("本页面会创建一个键盘监听和输入框")
            Text("本页面会创建一个键盘监听和输入框")
            Text("本页面会创建一个键盘监听和输入框")
            Text("本页面会创建一个键盘监听和输入框")
            Text("本页面会创建一个键盘监听和输入框")
            Text("本页面会创建一个键盘监听和输入框")
            Text("本页面会创建一个键盘监听和输入框")
            Text("本页面会创建一个键盘监听和输入框")
            
            TextField("请输入内容", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding()
                .foregroundColor(.green)
            
            
        }.onAppear {
            
            KeyboardToolbarConfig.shared.showToolBar = true
            
            return;
            
            let accessoryView = KBToolBar()
            accessoryView.backgroundColor = .red
            accessoryView.frame = CGRect(x: 0, y: .height, width: .width, height: 44)
            UIViewController.currentVisibleVC.view.window?.addSubview(accessoryView)
            accessoryView.addTap { sender in
                sender.window?.rootViewController?.view.endEditing(true)
            }
            
            // 设置键盘状态回调
            keyboardMonitor?.keyboardWillShow = { startFrame, endFrame, duration in
                print("Keyboard will show from frame: \(startFrame) to frame: \(endFrame) with duration: \(duration)")
                
                UIView.animate(withDuration: duration) {
                    accessoryView.transform = CGAffineTransform(translationX: 0, y: -endFrame.height - 44)
                }
            }
            
            keyboardMonitor?.keyboardDidShow = { startFrame, endFrame, duration in
                print("Keyboard did show from frame: \(startFrame) to frame: \(endFrame) with duration: \(duration)")
            }
            
            keyboardMonitor?.keyboardWillHide = { startFrame, endFrame, duration in
                print("Keyboard will hide from frame: \(startFrame) to frame: \(endFrame) with duration: \(duration)")
                
                UIView.animate(withDuration: duration) {
                    accessoryView.transform = .identity
                }
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

import UIKit

class KBToolBar: UIView {
    private let button = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent() {
        addSubview(button)

        button.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        button.addTap { sender in
            sender.window?.rootViewController?.view.endEditing(true)
        }
    }
}
