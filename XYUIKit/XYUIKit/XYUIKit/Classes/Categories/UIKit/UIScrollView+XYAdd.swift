//
//  UIScrollView+XYAdd.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2022/4/19.
//

import UIKit

public extension UIScrollView {
    
    /// 滚动到顶部
    /// - Parameter animated: 是否需要动画
    func scrollToTop(_ animated: Bool = true) {
        var offset = contentOffset
        offset.y = 0 - contentInset.top
        setContentOffset(offset, animated: animated)
    }
    
    /// 滚动到左边
    /// - Parameter animated: 是否需要动画
    func scrollToLeft(_ animated: Bool = true) {
        var offset = contentOffset
        offset.x = 0 - contentInset.left
        setContentOffset(offset, animated: animated)
    }
    
    /// 滚动到右边
    /// - Parameter animated: 是否需要动画
    func scrollToRight(_ animated: Bool = true) {
        var offset = contentOffset
        offset.x = contentSize.width - bounds.size.width + contentInset.right
        setContentOffset(offset, animated: animated)
    }
    
    /// 滚动到底部
    /// - Parameter animated: 是否需要动画
    func scrollToBottom(_ animated: Bool = true) {
        var offset = contentOffset
        offset.y = contentSize.height - bounds.size.height + contentInset.bottom
        setContentOffset(offset, animated: animated)
    }
}
