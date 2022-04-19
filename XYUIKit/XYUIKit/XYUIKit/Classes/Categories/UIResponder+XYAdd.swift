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
    func respondChainContains(_ className: UIResponder.Type) -> Bool {
        var nextRes = self.next
        while nextRes != nil {
            
            if let next = nextRes,
               type(of: next) == className {
                return true
            }
            nextRes = nextRes?.next
        }
        return false
    }
    
    /// 返回从当前开始的倒序响应者链条
    /// - Returns: self -> self.next -> self.next.next -> ...
    func respondChain() -> String {
        
        
        
        var result = "\(type(of: self))"
        
        var nextRes = self.next
        while nextRes != nil {
            
            if let next = nextRes {
                let className = type(of: next)
                result.append(" -> \(className)")
            }
            nextRes = nextRes?.next
        }
        
        return result
    }
}


