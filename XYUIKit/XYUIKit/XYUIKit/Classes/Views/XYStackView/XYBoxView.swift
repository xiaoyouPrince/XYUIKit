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
    public var edgeInsets = UIEdgeInsets.zero { didSet { layoutContent() } }
    
    public init(with subView: UIView, edgeInsets: UIEdgeInsets = .zero) {
        super.init(frame: .zero)
        addSubview(subView)
        self.edgeInsets = edgeInsets
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutContent(){
        if let subView = subviews.first {
            subView.snp.remakeConstraints { make in
                make.edges.equalTo(edgeInsets)
            }
        }
    }
}


