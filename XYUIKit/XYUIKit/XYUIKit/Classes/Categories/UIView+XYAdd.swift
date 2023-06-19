//
//  UIView+XYAdd.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2022/4/25.
//

import UIKit

public func cornerRadius(_ cornerRadius: CGFloat, forView view: UIView){
    view.layer.cornerRadius = cornerRadius
    view.clipsToBounds = true
}

public extension UIView {
    /// 切圆角
    /// - Parameter radius: 圆角大小
    func corner(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    /// 设置边框
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - width: 边框宽度
    func border(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}


// MARK: - 添加渐变色
public enum GradientType: Int, CustomStringConvertible {
    /// 上到下
    case top2bottom
    /// 左到右
    case left2Right
    /// 左上到右下
    case leftTop2rightBottom
    /// 左下到右上
    case leftBottom2rightTop
    
    /*
     [0,0] is the bottom-leftcorner of the layer,
     [1,1] is the top-right corner.)
     The default values are [.5,0] and [.5,1] */
    var startPoint: CGPoint {
        var start: CGPoint = .zero
        switch self {
        case .top2bottom:
            start = .init(x: 0, y: 0)
        case .left2Right:
            start = .init(x: 0, y: 0)
        case .leftTop2rightBottom:
            start = .init(x: 0, y: 0)
        case .leftBottom2rightTop:
            start = .init(x: 0, y: 1)
        }
        
        return start
    }
    
    var endPoint: CGPoint {
        var end: CGPoint = .zero
        switch self {
        case .top2bottom:
            end = .init(x: 0, y: 1)
        case .left2Right:
            end = .init(x: 1, y: 0)
        case .leftTop2rightBottom:
            end = .init(x: 1, y: 1)
        case .leftBottom2rightTop:
            end = .init(x: 1, y: 0)
        }
        
        return end
    }
    
    public var description: String{
        switch self {
        case .top2bottom:
            return "top2bottom"
        case .left2Right:
            return "left2Right"
        case .leftTop2rightBottom:
            return "leftTop2rightBottom"
        case .leftBottom2rightTop:
            return "leftBottom2rightTop"
        }
    }
}

public extension UIView {
    
    /// 给当前 UIView 设置渐变色
    /// - Parameters:
    ///   - type: 指定渐变类型
    ///   - size: 指定渐变色区域大小
    ///   - gradientColors: 渐变色颜色数组
    /// - Returns: 返回一个 CAGradientLayer，调用者可以自己管理返回值的生命周期，避免重复设置渐变色
    @discardableResult
    func setGradient(withType type: GradientType,
                     size: CGSize,
                     gradientColors: [UIColor]) -> CAGradientLayer{
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors.map({$0.cgColor})
        gradientLayer.startPoint = type.startPoint
        gradientLayer.endPoint = type.endPoint
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
}

public extension UIView {

    var viewController: UIViewController? {
        var nextRes = next
        while nextRes != nil {
            if let VC = nextRes as? UIViewController {
                return VC
            }
            nextRes = nextRes?.next
        }
        
        return nil
    }
}
