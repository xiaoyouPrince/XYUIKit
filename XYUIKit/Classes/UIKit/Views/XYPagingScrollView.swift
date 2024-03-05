//
//  XYPagingScrollView.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/3/5.
//
/*
 分页滚动视图
 可以用作首页 BannerView
 产品滚动展示 比如约车软件选择车型
 */

import UIKit

@objc @objcMembers public class XYPagingScrollView: UIView {
    public var itemSpacing: CGFloat = 10.0 { didSet{setupUI()} }
    public var pageWidth: CGFloat = 0.85
    public var showPageControl: Bool = true
    public var timeInterval: TimeInterval = 3.0
    public var customPages: [UIView]? { didSet{setupUI()} }
    public var imageUrls: [URL]?
    public var imageArary: [UIImage]?
    
    
    lazy var scrollView = getScrollView()
    lazy var enhanceScrollView = getEnhanceScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        if pageWidth < 0 || pageWidth > 1 { pageWidth = 0.85 }
        scrollView = getScrollView()
        
        backgroundColor = UIColor.white
        addSubview(scrollView)
        enhanceScrollView.scrollView = scrollView
        addSubview(enhanceScrollView)
        
        enhanceScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(pageWidth)
        }
    }
}

private extension XYPagingScrollView {
    func getScrollView() -> UIScrollView {
        let scrollView = XYScrollView()
        scrollView.itemSpacing = itemSpacing
        scrollView.customPages = customPages
        return scrollView
    }
    
    func getEnhanceScrollView() -> EnhanceScrollView {
        EnhanceScrollView()
    }
}


class XYScrollView: UIScrollView {
    var itemSpacing: CGFloat = 10.0
    var customPages: [UIView]?
    var imageUrls: [URL]?
    var imageArary: [UIImage]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func setupContent() {
        for (idx, page) in customPages!.enumerated() {
            addSubview(page)
            
            page.snp.makeConstraints { make in
                make.left.equalToSuperview().multipliedBy(idx).offset(itemSpacing / 2)
                make.top.equalToSuperview()
                make.width.equalToSuperview().offset(-itemSpacing)
                make.height.equalToSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EnhanceScrollView: UIScrollView {
    var scrollView: UIScrollView?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if(self.point(inside: point, with: event)) {
            return scrollView
        }
        return nil
    }
}
