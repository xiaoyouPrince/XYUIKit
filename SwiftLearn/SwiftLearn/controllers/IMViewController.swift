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
        
        let bar = IMInputBar(frame: .zero)
        view.addSubview(bar)
    }
}


/// 类会自适应高度，无需设置高度
class IMInputBar: UIView, UITextViewDelegate {
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
