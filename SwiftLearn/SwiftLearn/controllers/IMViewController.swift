//
//  IMViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/10/13.
//


import UIKit

class IMViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .groupTableViewBackground
        
        let bar = IMInputBar(frame: .zero)
        view.addSubview(bar)
        if #available(iOS 11.0, *) {
            bar.frame = CGRect(x: 0, y: self.view.bounds.height - 34 - 56, width: UIScreen.main.bounds.width, height: 56)
            
        } else {
            bar.frame = CGRect(x: 0, y: 420, width: UIScreen.main.bounds.width, height: 56)
        }
    }
}


/// 类会自适应高度，无需设置高度
class IMInputBar: UIView, UITextViewDelegate {
    
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
        self.addSubview(textView)
        return textView
    }()
    
    lazy var sendBtn: UIButton = {
        let sendBtn = UIButton()
        sendBtn.backgroundColor = UIColor.blue.withAlphaComponent(0.85)
        sendBtn.setTitle("发送", for: .normal)
        self.addSubview(sendBtn)
        return sendBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white
        
        textView.frame = CGRect(x: 12, y: 8, width: UIScreen.main.bounds.width - 100, height: 40)
        sendBtn.frame = CGRect(x: textView.frame.maxX + 12, y: 8, width: 70, height: 40)
        
//        self.frame = CGRect(x: 0, y: 420, width: UIScreen.main.bounds.width, height: 56)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        
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
}
