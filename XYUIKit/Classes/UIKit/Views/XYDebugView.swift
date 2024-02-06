//
//  XYDebugView.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/2/5.
//
//  XYDebugView 自定义一个全局 DEBUG 入口工具
//  XYDebugView.show() 即可使用

import UIKit

@objc public protocol XYDebugViewProtocol: NSObjectProtocol {
    /// debugView 被点击
    @objc func didClickDebugview()
}

@objc public class XYDebugView: UIView {
    static private var shared: XYDebugView!
    private var infoLabel: UILabel = .init()
    private weak var delegate: XYDebugViewProtocol? { didSet{ didSetDelegate() }}
    private var initialCenter: CGPoint = CGPoint()
    private var animator: UIViewPropertyAnimator?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public static func show(_ delegate: XYDebugViewProtocol? = nil){
        if let keyWindow = UIApplication.shared.getKeyWindow(), shared == nil {
            let debugView = XYDebugView()
            shared = debugView
            shared.delegate = delegate
            keyWindow.addSubview(debugView)
            debugView.frame = .init(x: .width - 100, y: .height - 300, width: 100, height: 100)
            debugView.corner(radius: 50)
        }
    }
    
    @objc public static func dismiss(){
        shared.removeFromSuperview()
        shared = nil
    }
}

extension XYDebugView {
    
    func setupContent() {
        backgroundColor = .random
        addPanGesture()
    }
    
    func didSetDelegate() {
        if let delegate = delegate {
            addTap { sender in
                delegate.didClickDebugview()
            }
        } else {
            setAction()
        }
    }
    
    func displayCustom() {
        addSubview(infoLabel)
        infoLabel.numberOfLines = 0
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(CGFloat.naviBar)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }
        infoLabel.text = """
            💡💡💡💡💡💡💡
            这是一个 Debug 工具入口, 当前页面是默认实现.
            
            理论上你要展示自己的内容, 这里需要自定义实现
            
            修改调用方式:
            
            let delegate = YourDelegate()
            XYDebugView.show(delegate)
            
            用你的 delegate 来响应真实事件的点击.
            
            请注意: delegate 是被弱引用的, 你需要自行对其保活
            """
    }
}

// MARK: - animations
private extension XYDebugView {
    func setAction() {
        addTap { [weak self] sender in
            guard let self = self else { return }
            let oldFrame = self.frame
            let oldColor = self.backgroundColor
            let oldRadius = self.layer.cornerRadius
            self.window!.addSubview(self)
            self.frame = oldFrame
            UIView.animate(withDuration: 0.25) {
                self.frame = self.superview?.bounds ?? .zero
                self.backgroundColor = .white
                self.displayCustom()
            } completion: { complete in
                if complete {
                    self.addTap { [weak self] sender in
                        guard let self = self else { return }
                        self.frame = self.window!.bounds
                        UIView.animate(withDuration: 0.25) {
                            self.frame = oldFrame
                            self.corner(radius: oldRadius)
                            self.backgroundColor = oldColor
                        } completion: { complete in
                            if complete {
                                self.setAction()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let targetView = gesture.view else { return }
        
        switch gesture.state {
        case .began:
            initialCenter = targetView.center
            startAnimation()
        case .changed:
            let translation = gesture.translation(in: self.superview)
            let newCenter = CGPoint(x: targetView.center.x + translation.x, y: targetView.center.y + translation.y)
            let minX = bounds.width / 2
            let maxX = superview!.bounds.width - bounds.width / 2
            let minY = bounds.height / 2
            let maxY = superview!.bounds.height - bounds.height / 2
            targetView.center = CGPoint(x: max(minX, min(newCenter.x, maxX)), y: max(minY, min(newCenter.y, maxY)))
            gesture.setTranslation(.zero, in: self.superview)
        case .cancelled, .ended:
            let translation = gesture.translation(in: self.superview)
            let newCenter = CGPoint(x: targetView.center.x + translation.x, y: targetView.center.y + translation.y)
            let minX = bounds.width / 2
            let maxX = superview!.bounds.width - bounds.width / 2
            let finalX = newCenter.x > superview!.bounds.width/2 ? maxX : minX
            UIView.animate(withDuration: 0.25) {
                targetView.center = CGPoint(x: finalX, y: newCenter.y)
            }
            gesture.setTranslation(.zero, in: self.superview)
            stopAnimation()
        default:
            break
        }
    }
    
    func startAnimation(){
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        animator?.startAnimation()
        
        Runlooper.startLoop(forKey: "mave", interval: 0.2) {
            let maveView = UIView(frame: .init(x: 0, y: 0, width: 1, height: 1))
            self.addSubview(maveView)
            maveView.center = .init(x: 50, y: 50)
            maveView.isUserInteractionEnabled = false
            maveView.backgroundColor = .white
            UIView.animate(withDuration: 1) {
                maveView.frame = self.bounds
                maveView.alpha = 0
                maveView.corner(radius: 50)
            } completion: { completion in
                maveView.removeFromSuperview()
            }
        }
    }
    
    func stopAnimation(){
        animator?.stopAnimation(true)
        animator = nil
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
        
        Runlooper.stopLoop(forKey: "mave")
    }
}
