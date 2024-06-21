//
//  KBTopInputView.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/6/18.
//
//  直接放在键盘上方的一个输入框

import UIKit
import YYUIKit
#if canImport(IQKeyboardManager)
import IQKeyboardManager
#endif

class KBTopInputView: UIView {
    static var heiget: CGFloat {
        get {
            if type == 0 { return 100}
            else if type == 1 { return 125}
            else { return 100}
        }
    }
    static private(set) var type: Int = 0 // 自身类型 0 tf /  1 tv
    private let bgView: UIView = .init()
    private let inputBg = UIView()
    private let textfield = UITextField()
    private let textView = UITextView()
    private let line = UIView.line
    private let clearBtn = UIButton(type: .system)
    private let okBtn = UIButton(type: .system)
    private let textChangeMonitor = TextChangeMonitor()
    private let keyboardMonitor: KeyboardMonitor! = .init()
    private var type: Int { KBTopInputView.type }// 自身类型 0 tf /  1 tv
    private var anchorView: UIView?
    
    var textChangeCallback: ((_ text: String) -> ())?
    var textEndEditingCallback: (() -> ())?
    
    override init(frame: CGRect) {
        KBTopInputView.type = 0
        super.init(frame: frame)
        setupContent()
        addMonitor()
    }
    
    /// 指定初始化类型
    /// - Parameter type: 0 : tf    1: tv
    init(type: Int) {
        KBTopInputView.type = type
        super.init(frame: .zero)
        setupContent(type: type)
        addMonitor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContent(type: Int = 0) {
        addSubview(inputBg)
        inputBg.addSubview(textfield)
        inputBg.addSubview(textView)
        addSubview(line)
        addSubview(clearBtn)
        addSubview(okBtn)
        
        inputBg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalTo(16)
            make.top.equalTo(12)
            if type == 0 {
                make.height.equalTo(KBTopInputView.heiget - 60)
            }
            else {
                make.height.equalTo(KBTopInputView.heiget - 60)
            }
        }
        
        if type == 0 {
            textfield.textColor = .xy_getColor(hex: 0x333333)
            textfield.font = .systemFont(ofSize: 14)
            textfield.returnKeyType = .done
            textfield.delegate = self
            textfield.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.center.equalToSuperview()
                make.top.equalToSuperview()
            }
        } else {
            textView.textColor = .xy_getColor(hex: 0x333333)
            textView.font = .systemFont(ofSize: 14)
            textView.backgroundColor = .clear
            textView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.center.equalToSuperview()
                make.top.equalToSuperview().offset(8)
            }
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
        
        clearBtn.setTitle(WDLocalizable("清空"), for: .normal)
        clearBtn.addTap {[weak self] sender in
            if type == 0 {
                self?.textfield.text = ""
                if let tf = self?.textfield {
                    self?.textChangeMonitor.onTextChanged?(tf, "")
                }
            } else {
                self?.textView.text = ""
                if let tf = self?.textView {
                    self?.textChangeMonitor.onTextChanged?(tf, "")
                }
            }
        }
        
        okBtn.setTitle(WDLocalizable("确定"), for: .normal)
        okBtn.addTap {[weak self] sender in
            self?.doneBtnClick()
        }
    }
    
    private func doneBtnClick() {
        _ = self.resignFirstResponder()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            self.dismiss()
        }
    }
    
    private func addMonitor() {
        textChangeMonitor.onTextChanged = {[weak self] view, text in
            if let tf = view as? UITextField, self?.textfield == tf {
                self?.textChangeCallback?(tf.text ?? "")
            }
            if let tf = view as? UITextView, self?.textView == tf {
                self?.textChangeCallback?(tf.text ?? "")
            }
        }
        
        textChangeMonitor.onEndEditing = {[weak self] view in
            if let tf = view as? UITextField, self?.textfield == tf {
                self?.textEndEditingCallback?()
            }
            if let tf = view as? UITextView, self?.textView == tf {
                self?.textEndEditingCallback?()
            }
        }
        
        keyboardMonitor?.keyboardWillShow = {[weak self] startFrame, endFrame, duration in
            self?.transform = CGAffineTransform(translationX: 0, y: -endFrame.height - KBTopInputView.heiget)
            if let anchorView = self?.anchorView {
                anchorView.frameOnScreen
            }
        }
        
        keyboardMonitor?.keyboardWillHide = {[weak self] startFrame, endFrame, duration in
            self?.transform = .identity
        }
    }
    
    func show() {
        if superview != nil { return }
        guard let view = UIViewController.currentVisibleVC.view.window else { return }
        
        #if canImport(IQKeyboardManager)
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        #endif
        
        view.addSubview(bgView)
        UIView.animate(withDuration: 0.25) {
            self.bgView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgView.addTap { [weak self] sender in
            _ = self?.resignFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                self?.dismiss()
            }
        }
        
        view.addSubview(self)
        self.frame = .init(x: 0, y: view.frame.maxY, width: view.frame.width, height: KBTopInputView.heiget)
        self.backgroundColor = .white
    }
    
    func dismiss() {
        self.removeFromSuperview()
        self.bgView.removeFromSuperview()
    }
    
    func updateText(_ text: String) {
        if type == 0 {
            self.textfield.text = text
            textChangeMonitor.onTextChanged?(self.textfield, text)
        } else {
            self.textView.text = text
            textChangeMonitor.onTextChanged?(self.textView, text)
        }
    }
    
    func setShowAnchorView(_ anchorView: UIView) {
        self.anchorView = anchorView
    }
    
    override func becomeFirstResponder() -> Bool {
        if type == 0 {
            self.textfield.becomeFirstResponder()
        } else {
            self.textView.becomeFirstResponder()
        }
        
    }
    
    override func resignFirstResponder() -> Bool {
        UIView.animate(withDuration: 0.25) {
            self.bgView.backgroundColor = .clear
        } completion: { complete in
            self.bgView.removeFromSuperview()
        }
        
        if type == 0 {
            return self.textfield.resignFirstResponder()
        } else {
            return self.textView.resignFirstResponder()
        }
        
    }
    
    deinit {
        Console.log("deinit")
    }
}

extension KBTopInputView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.doneBtnClick()
        return true
    }
    
}
