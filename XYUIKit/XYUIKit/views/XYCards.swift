//
//  XYCards.swift
//  XYUIKitDemo
//
//  Created by 渠晓友 on 2022/6/21.
//  Copyright © 2022 XYUIKit. All rights reserved.
//

import UIKit
import XYUIKIT

class XYCards: UIView {

    var iconView = UIImageView()
    var titleLabel = UILabel()
    var jobTitleLabel = UILabel()
    var timeLabel = UILabel()
    var meetidLabel = UILabel()
    var lineView = UIView()
    var btn = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = 12
    
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textColor = kHexColor(0x222222)
        
        jobTitleLabel.font = UIFont.systemFont(ofSize: 14)
        jobTitleLabel.textColor = kHexColor(0x666666)
        
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = kHexColor(0x666666)
        
        meetidLabel.font = UIFont.systemFont(ofSize: 14)
        meetidLabel.textColor = kHexColor(0x666666)
        
        lineView.backgroundColor = kHexColor(0xeeeeee)
        
        btn.setTitleColor(kHexColor(0x5b7be9), for: .normal)
        btn.setTitle("复制会议号进入面试间", for: .normal)
        
        [iconView,titleLabel,jobTitleLabel,timeLabel,meetidLabel,lineView,btn].forEach { view in
            addSubview(view)
            
            if view is UIImageView {
                view.backgroundColor = .red
            }
            
            if let label = view as? UILabel {
                label.text = "哈哈哈测试"
            }
        }
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.top.equalTo(10)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(15)
        }
        
        jobTitleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(jobTitleLabel.snp.bottom).offset(5)
        }
        
        meetidLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(5)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(meetidLabel.snp.bottom).offset(17)
        }
        
        btn.snp.makeConstraints { make in
            make.top.left.right.equalTo(lineView)
            make.height.equalTo(44)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
