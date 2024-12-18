//
//  XYTextChangeMonitor.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/6/17.
//
//  一个文本编辑监听工具
/* *************** 使用示例 *********************
 
     textChangeMonitor.onBeginEditing = { view in
         if let textField = view as? UITextField {
             print("开始编辑 UITextField")
         } else if let textView = view as? UITextView {
             print("开始编辑 UITextView")
         }
     }
     
     textChangeMonitor.onTextChanged = { view, text in
             if let textField = view as? UITextField {
             print("UITextField 文本变更: \(text)")
         } else if let textView = view as? UITextView {
             print("UITextView 文本变更: \(text)")
         }
     }
     
     textChangeMonitor.onEndEditing = { view in
             if let textField = view as? UITextField {
             print("结束编辑 UITextField")
         } else if let textView = view as? UITextView {
             print("结束编辑 UITextView")
         }
     }
 */

import UIKit

public typealias TextChangeMonitor = XYTextChangeMonitor
public class XYTextChangeMonitor {
    public var onBeginEditing: ((UIView) -> Void)?
    public var onTextChanged: ((UIView, String) -> Void)?
    public var onEndEditing: ((UIView) -> Void)?
    
    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing(_:)), name: UITextField.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing(_:)), name: UITextField.textDidEndEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing(_:)), name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidEndEditing(_:)), name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func textFieldDidBeginEditing(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            onBeginEditing?(textField)
        }
    }
    
    @objc private func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            onTextChanged?(textField, textField.text ?? "")
        }
    }
    
    @objc private func textFieldDidEndEditing(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            onEndEditing?(textField)
        }
    }
    
    @objc private func textViewDidBeginEditing(_ notification: Notification) {
        if let textView = notification.object as? UITextView {
            onBeginEditing?(textView)
        }
    }
    
    @objc private func textViewDidChange(_ notification: Notification) {
        if let textView = notification.object as? UITextView {
            onTextChanged?(textView, textView.text)
        }
    }
    
    @objc private func textViewDidEndEditing(_ notification: Notification) {
        if let textView = notification.object as? UITextView {
            onEndEditing?(textView)
        }
    }
}
