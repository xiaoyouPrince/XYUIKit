//
//  XYBadgeView.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2023/7/4.
//

/**
 XYBadgeView 是一个用于展示 红点/未读数 的小工具
 
 1. 内容自适应,文字类型
 2. 使用方仅需要正确设置其位置即可,无需修改 size. 当然也可以设置
 */

/*
 * - TODO -
 * <#这里输入你要做的事情描述#>
 * <#这里输入你要做的事情的一些思路#>
 *  <#1. ...#>
 *  <#2. ...#>
 */

import UIKit

@objc
public enum BadgeType: Int {
    case redDot
    case stringContext
    case onlineGreen
}

@objcMembers
public class XYBadgeView: UIView {
    var type: BadgeType = .stringContext
    lazy var contextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    public var content: String = "" {
        didSet {
            contextLabel.text = content
            updateLayout()
        }
    }
    
    public var intContent: Int = 0 {
        didSet {
            if intContent > 99 {
                contextLabel.text = "99+"
            } else {
                contextLabel.text = "\(intContent)"
            }
            updateLayout()
        }
    }
    
    public required init(type: BadgeType) {
        self.type = type
        super.init(frame: .zero)
        self.backgroundColor = .xy_getColor(hex: 0xF56C62)
        var radius: CGFloat = 4
        switch type {
        case .redDot:
            radius = 4
        case .stringContext:
            radius = 8
        case .onlineGreen:
            radius = 3
            self.backgroundColor = .xy_getColor(hex: 0x5BC7A4)
        }
        layer.cornerRadius = radius
        clipsToBounds = true
        if type == .stringContext {
            addSubview(contextLabel)
            contextLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        switch type {
        case .redDot:
            return CGSize(width: 8, height: 8)
        case .stringContext:
            return CGSize(width: max(contextLabel.intrinsicContentSize.width + 8, 16), height: 16)
        case .onlineGreen:
            return CGSize(width: 6, height: 6)
        }
    }
    
    private func updateLayout() {
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
