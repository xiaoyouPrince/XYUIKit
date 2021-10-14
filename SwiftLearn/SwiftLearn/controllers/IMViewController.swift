//
//  IMViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/10/13.
//

func isIPhoneX() -> Bool {
    return UIApplication.shared.statusBarFrame.height != 20
}
func bottomSafeH() -> CGFloat {
    return isIPhoneX() ? 34 : 0
}

import UIKit

class IMViewController: UIViewController {
    
    var bar = IMInputBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .groupTableViewBackground
        
        bar = IMInputBar(frame: .zero)
        view.addSubview(bar)
    
        //bar.frame = CGRect(x: 0, y: self.view.bounds.height - 56, width: view.bounds.width, height: 56)
        bar.frame.origin.y = 100
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bar.textView.resignFirstResponder()
    }
}


/// 类会自适应高度，无需设置高度
/// 初始默认高度 56，默认会设置 frame 为 screen 宽度
class IMInputBar: UIView {
    
    // MARK: - 私有属性内部使用
    /// 上次高度，内部自适应输入内容高度
    private var lastHeight: CGFloat = 0
    
    // MARK: - 共有有属性，可外部使用
    /// 默认自适应高度最大值，当输入内容自适应高度大于此值，不再变高，输入内容变为可滚动
    var maxHeight: CGFloat = 100
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.backgroundColor = .red//UIColor.groupTableViewBackground
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 16)
        textView.returnKeyType = .send
        self.addSubview(textView)
        return textView
    }()
    
    lazy var sendBtn: UIButton = {
        let sendBtn = UIButton()
        sendBtn.backgroundColor = UIColor.blue.withAlphaComponent(0.85)
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.addTarget(self, action: #selector(sendBtnClick), for: .touchUpInside)
        self.addSubview(sendBtn)
        return sendBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white
        
        textView.frame = CGRect(x: 12, y: 8, width: UIScreen.main.bounds.width - 100, height: 40)
        sendBtn.frame = CGRect(x: textView.frame.maxX + 12, y: 8, width: 70, height: 40)
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 56)
        
        self.addKeyNotification()
    }
    
    @objc func sendBtnClick(){
        
        if textView.inputView == nil {
            
            textView.resignFirstResponder()
            let inputView = UIView()
            inputView.backgroundColor = .green
            inputView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
            
            textView.inputView = inputView
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.textView.becomeFirstResponder()
            }
        }else{
            textView.resignFirstResponder()
            textView.inputView = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.textView.becomeFirstResponder()
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /// textView 内部内容改动时候适配高度
    /// - Parameter textView: 调整的 textView，即内部 textView
    func adjustSelfFrame(with textView: UITextView){
        
        lastHeight = textView.frame.height
        // print(textView.contentSize)
        if textView.contentSize.height > textView.bounds.height {
            
            if textView.contentSize.height > maxHeight {return}
            
            textView.frame = CGRect(x: textView.frame.origin.x, y: textView.frame.origin.y, width: textView.frame.size.width, height: textView.contentSize.height)
            
            let deltaH = textView.frame.height - lastHeight
            let newselfHeight = textView.frame.height + 16
            
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - deltaH, width: self.frame.size.width, height: newselfHeight)
            adjustSubViewsFrame(textView)
            
        }else{
            
            if textView.bounds.height <= 40 {return}
            if textView.contentSize.height <= 40 {

                textView.frame = CGRect(x: textView.frame.origin.x, y: textView.frame.origin.y, width: textView.frame.size.width, height: 40)
                
                let newselfHeight = textView.frame.height + 16
                let deltaH = newselfHeight - self.frame.height
                
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - deltaH, width: self.frame.size.width, height: newselfHeight)
                adjustSubViewsFrame(textView)
            }else{
                textView.frame = CGRect(x: textView.frame.origin.x, y: textView.frame.origin.y, width: textView.frame.size.width, height: textView.contentSize.height)
                
                let deltaH = textView.frame.height - lastHeight
                let newselfHeight = textView.frame.height + 16
                
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - deltaH, width: self.frame.size.width, height: newselfHeight)
                adjustSubViewsFrame(textView)
            }
        }
    }
    
    /// 调整内部 view 的 frame，当 self.frame 发生改变时调用
    /// - Parameter except: 指定不需调整的View，默认是内部 textView
    func adjustSubViewsFrame(_ except: UIView) {
        for subView in self.subviews {
            if subView == except {
                continue
            }else{
                let vInset = (self.bounds.height - self.textView.bounds.height) / 2
                subView.frame = CGRect(x: subView.frame.origin.x, y: self.bounds.height - subView.frame.size.height - vInset, width: subView.frame.size.width, height: subView.frame.size.height)
            }
        }
    }
    
    
    func addKeyNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: IMInputBar.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: IMInputBar.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ noti: Notification){
        print(noti)
        guard let userInfo = noti.userInfo as? [String: Any],
            let kbEndFrame = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect,
            let time = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval else {
            return
        }

        if time == 0 {
            self.layer.removeAllAnimations()
            let deltaY = self.frame.origin.y - kbEndFrame.origin.y + self.frame.height
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - deltaY, width: self.frame.size.width, height: self.frame.size.height)
            return
        }
        UIView.animate(withDuration: time, delay: 0, options: .allowAnimatedContent) {
            let deltaY = self.frame.origin.y - kbEndFrame.origin.y + self.frame.height
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - deltaY, width: self.frame.size.width, height: self.frame.size.height)
        } completion: { finish in }
    }
    
    @objc func keyboardWillHide(_ noti: Notification){
        print(noti)
        guard let userInfo = noti.userInfo as? [String: Any],
            let kbEndFrame = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect,
            let time = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval else {
            return
        }
        
        if time == 0 {
            self.layer.removeAllAnimations()
            let deltaY = self.frame.origin.y - kbEndFrame.origin.y + self.frame.height + bottomSafeH()
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - deltaY, width: self.frame.size.width, height: self.frame.size.height)
            return
        }
        UIView.animate(withDuration: time, delay: 0, options: .allowAnimatedContent) {
            let deltaY = self.frame.origin.y - kbEndFrame.origin.y + self.frame.height + bottomSafeH()
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - deltaY, width: self.frame.size.width, height: self.frame.size.height)
        } completion: { finish in }
    }
}

extension IMInputBar: UITextViewDelegate {
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        adjustSelfFrame(with: textView)
    }
    

}
