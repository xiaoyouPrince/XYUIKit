//
//  UILabel+XYAdd.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/4/24.
//

import UIKit

public extension UILabel {
    
    
    /// 快速创建一个 tip
    /// - Parameters:
    ///   - tip: 要展示的文字
    ///   - superView: 要加载到的视图， default is keyWindow
    ///   - textColor: 文字颜色
    ///   - bgColor: tip 本身背景颜色
    ///   - fontSize: 文字字号大小
    ///   - edgeInsets: 文字与背景之间的边距(文字本身是居中)
    ///   - cornerRadius: 背景圆角
    ///   - animationDuration: 动画时间
    ///   - exitsTime: 存在的时间
    static func xy_showTip(_ tip: String,
                 onView: UIView,
                 _ textColor: UIColor = .white,
                 _ bgColor: UIColor = UIColor.black.withAlphaComponent(0.85),
                 _ fontSize: CGFloat = 14,
                 _ edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8),
                 _ cornerRadius: CGFloat = 5,
                 _ animationDuration: TimeInterval = 0.25,
                 _ exitsTime: TimeInterval = 2 ){
        let label = UILabel()
        label.text = tip
        
        onView.addSubview(label)
        
        label.backgroundColor = bgColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textColor = textColor
        label.alpha = 0.01
        label.numberOfLines = 0
        
        label.sizeToFit()
        let maxWidth = label.superview!.bounds.size.width - 60
        label.frame.size = CGSize(width: label.frame.size.width + edgeInsets.left + edgeInsets.right, height: label.frame.size.height + edgeInsets.top + edgeInsets.bottom)
        if label.bounds.size.width > maxWidth {
            let attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
            let attrTip = NSAttributedString(string: tip, attributes: attr)
            let boundingRect = attrTip.boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
            let realHeight = ceil(boundingRect.height)
            label.frame.size = CGSize(width: maxWidth, height: realHeight + 20)
        }
        label.center = label.superview!.center
        
        UIView.animate(withDuration: animationDuration) {
            label.alpha = 1
        }
        
        var exitsTime_ = exitsTime
        if tip.unicodeScalars.count > 10 {
            exitsTime_ = TimeInterval(tip.unicodeScalars.count / 5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + exitsTime_) {
            label.removeFromSuperview()
        }
    }
    
    
    /// 快速创建一个label
    /// - Parameters:
    ///   - title: 文本
    ///   - font: 字号
    ///   - textColor: 字体颜色
    ///   - textAlignment: 对齐方式
    convenience init(title: String?, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment){
        self.init(frame: .zero)
        self.text = title
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
    }
    
}
