//
//  UIResponder+XYAdd.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/8/18.
//

import UIKit

public extension UIResponder {
    
    /// 判断响应者链条是否包含某具体类
    /// - Parameter className: 需要被检测的类型
    /// - Returns: true/false
    func responderChainContains(_ className: UIResponder.Type) -> Bool {
        return responderChainToString.contains(className.debugDescription())
    }
    
    /// 返回从当前开始的响应者链条
    /// - Returns: [UIResponder]
    var responderChain: [UIResponder] {
        var result = [self]
        
        var nextRes = self.next
        while nextRes != nil {
            if let next = nextRes {
                result.append(next)
            }
            nextRes = nextRes?.next
        }
        
        return result
    }
    
    /// 返回从当前开始的倒序响应者链条
    /// - Returns: self -> self.next -> self.next.next -> ...
    var responderChainToString: String {
        var result = "\(type(of: self).debugDescription())"
        for chain in responderChain.dropFirst() {
            result.append(" -> \(type(of: chain).debugDescription())")
        }
        return result
    }
}


