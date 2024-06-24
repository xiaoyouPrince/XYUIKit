//
//  XYKeyboardToolbar.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/6/14.
//
/* KeyboardToolbarConfig - 键盘管理配置工具 -
 * *********************************************
 * *************** USAGE ***********************
 
 // 在适当的时机设置键盘工具可用即可
 KeyboardToolbarConfig.shared.showToolBar = true
 
 */

import UIKit

@objc @objcMembers public class KeyboardToolbarConfig: NSObject {
    public static let shared: KeyboardToolbarConfig = .init()
    /// 是否展示键盘工具条
    public var showToolBar: Bool = false
    /// 键盘工具条展示时，距离textField / textView 的距离， 默认 10
    public var toolbarDistanceFromTextField: CGFloat = 10
    
    private var keyboardMonitor: KeyboardMonitor!
    private var accessoryView: XYKeyboardToolbar!
    private var textChangeMonitor: XYTextChangeMonitor!
    private weak var currentTF: UIView?//UITextField ? UITextView
    
    private override init() {
        let barHeight: CGFloat = 44
        keyboardMonitor = .init()
        accessoryView = .init(frame: .init(x: 0, y: .height, width: .width, height: barHeight))
        textChangeMonitor = .init()
        UIApplication.getKeyWindow()?.addSubview(accessoryView)
        super.init()
        
        // 设置键盘状态回调
        keyboardMonitor?.keyboardWillShow = {[weak self] startFrame, endFrame, duration in
            if endFrame == startFrame { return }
            
            UIView.animate(withDuration: duration) { [weak self] in
                // 直接计算自身的真实需要移动的 height
                if let contenterView = self?.getTargetTextFiled(), let window = contenterView.window {
                    let windowFrame = contenterView.convert(contenterView.bounds, to: window)
                    
                    let tfEndY = CGFloat.height - (endFrame.height + 44 + windowFrame.height + (self?.toolbarDistanceFromTextField ?? 10))
                    if tfEndY < windowFrame.minY  {
                        let transY = windowFrame.minY - tfEndY
                        UIView.animate(withDuration: duration) {
                            window.transform = CGAffineTransform(translationX: 0, y: -transY)
                        }
                        
                        self?.accessoryView.transform = CGAffineTransform(translationX: 0, y: -endFrame.height - barHeight + transY)
                    } else {
                        self?.accessoryView.transform = CGAffineTransform(translationX: 0, y: -endFrame.height - barHeight)
                    }
                }
            }
        }
        
        keyboardMonitor?.keyboardWillHide = {[weak self] startFrame, endFrame, duration in
            UIView.animate(withDuration: duration) { [weak self] in
                self?.accessoryView.transform = .identity
                self?.getTargetTextFiled()?.window?.transform = .identity
            }
        }
        
        textChangeMonitor.onBeginEditing = {[weak self] view in
            self?.currentTF = view
        }
    }
    
}

private extension KeyboardToolbarConfig {
    
    var isSwiftUI: Bool {
        currentTF?.responderChainToString.contains("UIHostingController") ?? false
    }
    
    func getTargetTextFiled() -> UIView? {
        // SwiftUI TextFiled 会用 UIView 来包装一层 UITextField
        if currentTF?.frame.origin == .zero, let contenterView = currentTF?.superview {
            return contenterView
        } else {
            // UIKit
            return currentTF
        }
    }
}

private class XYKeyboardToolbar: UIView {
    
    private let topLine = UIView.line
    private let button = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent() {
        backgroundColor = .xy_getColor(hex: 0xF0F2F3)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        
        addSubview(topLine)
        addSubview(button)
        
        topLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topLine.topAnchor.constraint(equalTo: self.topAnchor),
            topLine.heightAnchor.constraint(equalToConstant: .line)
        ])
        
        button.setTitle(LocalizedStringHelper.localizedString(forKey: "Done"), for: .normal)
//        button.setTitle(YYUIKitLocalizable("Done"), for: .normal)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.rightAnchor.constraint(equalTo: blurEffectView.contentView.rightAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: blurEffectView.contentView.centerYAnchor)
        ])
        
        button.addTap { sender in
            sender.window?.rootViewController?.view.endEditing(true)
        }
    }
}
