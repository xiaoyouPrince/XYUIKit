//
//  XYBoxView.swift
//  Masonry
//
//  Created by 渠晓友 on 2023/8/27.
//

import UIKit

@available(iOS 9.0, *)
public class VStack: UIStackView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        distribution = .fill
        alignment = .center
    }
    
    public convenience init(spacing: CGFloat){
        self.init(frame: .zero)
        self.spacing = spacing
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available(iOS 9.0, *)
public class HStack: UIStackView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        distribution = .fill
        alignment = .center
    }
    
    public convenience init(spacing: CGFloat){
        self.init(frame: .zero)
        self.spacing = spacing
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public typealias BoxView = XYBoxView
public class XYBoxView: UIView {
    public var edgeInsets: UIEdgeInsets { didSet { updateContent() } }
    public private(set) var view: UIView
    
    /// 初始化一个 BoxView
    /// - Parameters:
    ///   - subView: 需要被包裹的 view
    ///   - edgeInsets: 内边距
    public init(with subView: UIView, edgeInsets: UIEdgeInsets = .zero) {
        self.edgeInsets = edgeInsets
        self.view = subView
        super.init(frame: .zero)
        addSubview(subView)
        layoutContent()
    }
    
    /// 初始化一个 BoxView
    /// - Parameters:
    ///   - title: 标题
    ///   - edgeInsets: 内边距
    public init(withTitle title: String, font: UIFont = .systemFont(ofSize: 17), edgeInsets: UIEdgeInsets = .zero) {
        self.edgeInsets = edgeInsets
        let label = UILabel()
        self.view = label
        super.init(frame: .zero)
        
        label.font = font
        label.text = title
        addSubview(label)
        layoutContent()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutContent(){
        if let subView = subviews.first {
            subView.snp.remakeConstraints({ make in
                make.left.equalToSuperview().offset(edgeInsets.left)
                make.top.equalToSuperview().offset(edgeInsets.top)
                make.right.equalToSuperview().offset(-edgeInsets.right)
                make.bottom.equalToSuperview().offset(-edgeInsets.bottom)
            })
        }
    }
    
    private func updateContent(){
        if let subView = subviews.first {
            subView.snp.updateConstraints { make in
                subView.snp.remakeConstraints({ make in
                    make.left.equalToSuperview().offset(edgeInsets.left)
                    make.top.equalToSuperview().offset(edgeInsets.top)
                    make.right.equalToSuperview().offset(-edgeInsets.right)
                    make.bottom.equalToSuperview().offset(-edgeInsets.bottom)
                })
            }
        }
    }
}

extension UIView {
    /// 快速封装一个边距
    /// - Parameters:
    /// - Parameter edgeInsets: 内边距
    /// - Returns: 返回 BoxView
    public func boxView(with edgeInsets: UIEdgeInsets = .zero) -> BoxView {
        BoxView(with: self, edgeInsets: edgeInsets)
    }
    
    /// 快速封装一个边距
    /// - Parameters:
    ///   - top: top
    ///   - left: left
    ///   - bottom: bottom
    ///   - right: right
    /// - Returns: 返回 BoxView
    public func boxView(top: CGFloat = .zero, left: CGFloat = .zero, bottom: CGFloat = .zero, right: CGFloat = .zero) -> BoxView {
        BoxView(with: self, edgeInsets: .init(top: top, left: left, bottom: bottom, right: right))
    }
    

}


