//
//  KBTopInputView.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/6/18.
//
//  直接放在键盘上方的一个输入框

import UIKit
import YYUIKit

class KBTopInputView: UIView {
    static private let heiget: CGFloat = 100
    private let bgView: UIView = .init()
    private let inputBg = UIView()
    private let textfield = UITextField()
    private let line = UIView.line
    private let clearBtn = UIButton(type: .system)
    private let okBtn = UIButton(type: .system)
    private let textChangeMonitor = TextChangeMonitor()
    private let keyboardMonitor: KeyboardMonitor! = .init()
    
    var textChangeCallback: ((_ text: String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
        addMonitor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContent() {
        addSubview(bgView)
        addSubview(inputBg)
        inputBg.addSubview(textfield)
        addSubview(line)
        addSubview(clearBtn)
        addSubview(okBtn)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        inputBg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalTo(16)
            make.top.equalTo(12)
            make.height.equalTo(40)
        }
        
        textfield.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.center.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(CGFloat.line)
        }
        
        clearBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(20)
        }
        
        okBtn.snp.makeConstraints { make in
            make.centerY.equalTo(clearBtn)
            make.right.equalToSuperview().offset(-16)
        }
        
        corner(radius: 16, markedCorner: 3)
        
        inputBg.backgroundColor = .xy_getColor(hex: 0xf8f9fc)
        inputBg.corner(radius: 8)
        
        clearBtn.setTitle("清空", for: .normal)
        clearBtn.addTap {[weak self] sender in
            self?.textfield.text = ""
        }
        
        okBtn.setTitle("确定", for: .normal)
        okBtn.addTap {[weak self] sender in
            _ = self?.resignFirstResponder()
        }
    }
    
    func addMonitor() {
        textChangeMonitor.onTextChanged = {[weak self] view, text in
            if let tf = view as? UITextField, self?.textfield == tf {
                self?.textChangeCallback?(tf.text ?? "")
            }
        }
        
        keyboardMonitor?.keyboardWillShow = {[weak self] startFrame, endFrame, duration in
            self?.transform = CGAffineTransform(translationX: 0, y: -endFrame.height - KBTopInputView.heiget)
        }
        
        keyboardMonitor?.keyboardWillHide = {[weak self] startFrame, endFrame, duration in
            self?.transform = .identity
        }
    }
    
    func show() {
        if superview != nil { return }
        guard let view = UIViewController.currentVisibleVC.view else { return }
        view.addSubview(self)
        self.frame = .init(x: 0, y: view.frame.maxY, width: view.frame.width, height: KBTopInputView.heiget)
        self.backgroundColor = .white
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    override func becomeFirstResponder() -> Bool {
        self.textfield.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.textfield.resignFirstResponder()
    }
}
