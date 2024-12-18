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
    /// 设置 item 之间间距
    public var itemSpacing: CGFloat = 10.0 { didSet{setupUI()} }
    /// 设置 page 相对整个 view 宽度的百分比， 范围为 0 - 1
    public var pageWidth: CGFloat = 1.0
    /// 数据源， 即要展示的具体页面 view 数组
    public var customPages: [UIView]? { didSet{setupUI()} }
    /// 设置初始状态默认选中第几个， 默认第 0 个
    public var initinalIndex: Int = 0
    /// 设置非当前页面时候 item 的缩放百分比，范围为 0 - 1， 默认为 1.0，表示不缩放
    public var scaleRatioForUncurrentPage: CGFloat = 1.0
    public lazy var scrollView = getScrollView()
    lazy var enhanceScrollView = getEnhanceScrollView()
    public var currentPageCallBack: ((_ idx: Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        if pageWidth < 0 || pageWidth > 1 { pageWidth = 1.0 }
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
    
    deinit {
        Console.log("被销毁")
    }
}

private extension XYPagingScrollView {
    func getScrollView() -> UIScrollView {
        let scrollView = XYScrollView()
        scrollView.itemSpacing = itemSpacing
        scrollView.initinalIndex = initinalIndex
        scrollView.customPages = customPages
        scrollView.scaleRatioForUncurrentPage = scaleRatioForUncurrentPage
        scrollView.currentPageCallBack = {[weak self] in self?.currentPageCallBack?($0) }
        return scrollView
    }
    
    func getEnhanceScrollView() -> EnhanceScrollView {
        EnhanceScrollView()
    }
}


class XYScrollView: UIScrollView, UIScrollViewDelegate {
    var itemSpacing: CGFloat = 10.0
    var customPages: [UIView]? { didSet { if customPages != nil {setupContent()} }}
    var initinalIndex: Int = 0
    var currentPageCallBack: ((_ idx: Int)->())?
    var scaleRatioForUncurrentPage: CGFloat = 1.0
    
    private var contentView: UIView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        clipsToBounds = false
        scrollsToTop = false
        delegate = self
    }
    
    func setupContent() {
        
        contentView.subviews.forEach{($0.removeFromSuperview())}
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        for (idx, page) in customPages!.enumerated() {
            contentView.addSubview(page)
            
            page.snp.makeConstraints { make in
                if idx == 0 {
                    make.left.equalToSuperview().offset(itemSpacing / 2)
                }else{
                    make.left.equalTo(customPages![idx-1].snp.right).offset(itemSpacing)
                }
                make.top.equalToSuperview()
                make.width.equalTo(self) .offset(-itemSpacing)
                make.height.equalTo(self)
            }
            
            if idx == customPages!.count - 1 {
                page.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-(itemSpacing / 2))
                }
            }
        }
        
        DispatchQueue.main.async {
            var contentOffSet_ = self.contentOffset
            contentOffSet_.x = CGFloat(self.initinalIndex) * self.bounds.width
            self.contentOffset = contentOffSet_
            self.delegate?.scrollViewDidScroll?(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x / scrollView.bounds.width) + 0.5)
        currentPageCallBack?(page)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = (scrollView.contentOffset.x / scrollView.bounds.width)
        /* 仅需要计算， 中心页&两边共三个即可， 其他的按照最小缩放比直接设置*/
        
        if let views = customPages {
            for (idx, view) in views.enumerated() {
                let scale = 1 - abs(CGFloat(idx) - page) * (1 - scaleRatioForUncurrentPage)/*0.1*/
                view.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
    }
    
}

class EnhanceScrollView: UIScrollView {
    var scrollView: UIScrollView?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if(self.point(inside: point, with: event)) {
            if scrollView?.point(inside: point, with: event) == true {
                let rst = scrollView?.subviews.first!.hitTest(self.convert(point, to: scrollView?.subviews.first!), with: event)
                return rst
            }
            if scrollView?.subviews.first!.point(inside: point, with: event) == true {
                let rst = scrollView?.subviews.first!.hitTest(self.convert(point, to: scrollView?.subviews.first!), with: event)
                return rst
            }
            return scrollView
        }
        return nil
    }
}
