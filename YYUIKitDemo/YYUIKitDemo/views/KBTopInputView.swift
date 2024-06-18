//
//  KBTopInputView.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/6/18.
//

import UIKit
import YYUIKit

class KBTopInputView: UIView {
    private let bgView: UIView = .init()
    private let inputBg = UIView()
    private let textfield = UITextField()
    private let line = UIView.line
    private let clearBtn = UIButton(type: .system)
    private let okBtn = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent() {
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
        }
        
        clearBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(10)
        }
        
        clearBtn.snp.makeConstraints { make in
            make.centerY.equalTo(clearBtn)
            make.right.equalToSuperview().offset(-16)
        }
    }
}
