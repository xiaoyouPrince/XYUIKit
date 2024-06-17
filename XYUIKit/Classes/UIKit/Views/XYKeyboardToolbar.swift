//
//  XYKeyboardToolbar.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/6/14.
//

import UIKit

@objc @objcMembers public class KeyboardToolbarConfig: NSObject {
    public static let shared: KeyboardToolbarConfig = .init()
    /// 是否展示键盘工具条
    public var showToolBar: Bool = false
    
    private var keyboardMonitor: KeyboardMonitor!
    private var accessoryView: XYKeyboardToolbar!
    
    private override init() {
        let barHeight: CGFloat = 44
        keyboardMonitor = .init()
        accessoryView = .init(frame: .init(x: 0, y: .height, width: .width, height: barHeight))
        UIApplication.getKeyWindow()?.addSubview(accessoryView)
        super.init()
        
        // 设置键盘状态回调
        keyboardMonitor?.keyboardWillShow = { startFrame, endFrame, duration in
            //print("Keyboard will show from frame: \(startFrame) to frame: \(endFrame) with duration: \(duration)")
            
            UIView.animate(withDuration: duration) {
                self.accessoryView.transform = CGAffineTransform(translationX: 0, y: -endFrame.height - barHeight)
            }
        }
        
        keyboardMonitor?.keyboardWillHide = { startFrame, endFrame, duration in
            //print("Keyboard will hide from frame: \(startFrame) to frame: \(endFrame) with duration: \(duration)")
            
            UIView.animate(withDuration: duration) {
                self.accessoryView.transform = .identity
            }
        }
    }
    
}

class XYKeyboardToolbar: UIView {
    
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
