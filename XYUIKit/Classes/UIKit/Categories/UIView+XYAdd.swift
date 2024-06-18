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
    
    /// 切圆角
    /// - Parameter radius: 圆角大小
    /// - Parameter markedCorner: 指定要切的圆角 1/2/4/8 分别代表四个角, 可以用各个角的加和来组合
    @available(iOS 11.0, *)
    func corner(radius: CGFloat, markedCorner: UInt) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.maskedCorners = .init(rawValue: markedCorner)
    }
    
    /// 设置边框
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - width: 边框宽度
    func border(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    /// 设置 shadow
    /// - Parameters:
    ///   - color: shadow 的颜色
    ///   - radius: 圆角
    ///   - offset: 偏移量
    ///   - opacity: 不透明度 0-1
    func shadow(color: CGColor, radius: CGFloat = 10, offset: CGSize = .zero, opacity: Float = 0.5){
        clipsToBounds = false
        backgroundColor = .init(cgColor: color)
        layer.cornerRadius = radius
        layer.shadowRadius = radius
        layer.shadowColor = color
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
    }
    
    /// 返回一个 1 像素的横线
    static var line: UIView {
        let line = UIView.init(frame: .init(origin: .zero, size: .init(width: .width, height: .line)))
        line.backgroundColor = UIColor.line
        return line
    }
    
}

public extension UIView {
    
    /// 给 UIView 快速添加系统 blur 效果
    /// - Parameter style: 模糊类型
    func addBlurEffect(style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
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
    
    /// 当前 View 所属的控制器
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
    
    /// 是否在屏幕上可见
    var isOnScreen: Bool {
        if let window = self.window {
            let rect = self.convert(bounds, to: window)
            return rect.intersects(window.bounds)
        }
        return false
    }
}

// MARK: - 给 UIView 添加一个 tap 事件 & longpress 事件

public extension UIView {
    
    typealias viewTapCallBack = (_ sender: UIView)->()
    fileprivate struct AssociatedKeys {
        static var viewTapCallbackKey: String = "viewTapKey"
        static var viewLongPressGestureKey: String = "viewLongPressGestureKey"
        static var viewLongPressCallbackKey: String = "viewLongPressKey"
    }
    
    // MARK: - view tap 回调
    @objc private var viewTapCallback: (viewTapCallBack)? {
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.viewTapCallbackKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            guard let viewTapCallback = objc_getAssociatedObject(self, &AssociatedKeys.viewTapCallbackKey) as? viewTapCallBack else {
                return nil
            }
            return viewTapCallback
        }
    }
    
    /// 给当前 view 添加 tap 事件,并设置回调
    /// - Parameter callback: 所添加的 tap 事件回调, 参数为被 tap 对象本身, 内部若引用其他强指针需自行进行内存处理
    @discardableResult
    func addTap(callback: @escaping viewTapCallBack) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapGestureAction))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
        viewTapCallback = callback
        return tap
    }
    
    @objc fileprivate func viewTapGestureAction() {
        viewTapCallback?(self)
    }
    
    // MARK: - view longPress 回调
    @objc private var viewLongPress: (UILongPressGestureRecognizer)? {
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.viewLongPressGestureKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            guard let longPress = objc_getAssociatedObject(self, &AssociatedKeys.viewLongPressGestureKey) as? UILongPressGestureRecognizer else {
                return nil
            }
            return longPress
        }
    }
    @objc private var viewLongPressCallback: (viewTapCallBack)? {
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.viewLongPressCallbackKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            guard let viewTapCallback = objc_getAssociatedObject(self, &AssociatedKeys.viewLongPressCallbackKey) as? viewTapCallBack else {
                return nil
            }
            return viewTapCallback
        }
    }
    
    /// 给当前 view 添加 long press 事件,并设置回调
    /// - Parameter callback: 所添加的 longpress 事件回调, 参数为被 longpress 对象本身, 内部若引用其他强指针需自行进行内存处理
    @discardableResult
    func addLongPress(callback: @escaping viewTapCallBack) -> UILongPressGestureRecognizer {
        if let viewLongPress = viewLongPress {
            return viewLongPress
        }
        
        viewLongPress?.removeTarget(nil, action: nil)
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(viewLongPressGestureAction))
        isUserInteractionEnabled = true
        addGestureRecognizer(longpress)
        viewLongPressCallback = callback
        viewLongPress = longpress
        return longpress
    }
    
    @objc fileprivate func viewLongPressGestureAction() {
        viewLongPressCallback?(self)
    }
}

public extension UIView {
    
    /// 找到指定子视图
    /// - Parameter where: 返回找到的子视图,调用方可做自己的事 如:拿出子视图的引用
    /// - 回调的参数返回值是 Bool 类型,返回 true 代表找到目标 view, 会停止后续查找 
    func findSubView(where callback: (UIView)->(Bool)) {
        for subview in subviews {
            let find = callback(subview)
            if find == true {
                return
            }
        }
    }
    
    /// 递归找到指定子视图
    /// - Parameter where: 返回找到的子视图,调用方可做自己的事 如:拿出子视图的引用, 调整属性等
    /// - 回调的参数返回值是 Bool 类型,返回 true 代表找到目标 view, 会停止后续查找
    func findSubViewRecursion(where callback: (UIView)->(Bool)) {
        for subView in subviews {
            let find = callback(subView)
            if find == true {
                return
            }
            subView.findSubViewRecursion(where: callback)
        }
    }
    
}

public extension UIView {
    
    /// 返回视图快照
    @objc var snapshotImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 给指定角,切圆角
    /// - Parameters:
    ///   - cornerRadius: 圆角半径
    ///   - byRoundingCorners: 角
    func bezierPath(cornerRadius: CGFloat, byRoundingCorners: UIRectCorner = .allCorners) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: byRoundingCorners, cornerRadii:CGSize(width:cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

