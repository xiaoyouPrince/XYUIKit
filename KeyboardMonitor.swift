//
//  KeyboardMonitor.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/6/11.
//
//  一个简单的键盘状态监听工具

import Foundation

class KeyboardMonitor: NSObject {
    static let shared: KeyboardMonitor = .init()
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    @objc func keyBoardWillShow() {
        
    }
}
