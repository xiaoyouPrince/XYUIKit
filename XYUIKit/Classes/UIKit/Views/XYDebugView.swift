//
//  XYDebugView.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/2/5.
//

import UIKit

@objc public class XYDebugView: UIView {
    static private var shared: XYDebugView!
    private let iconView = UIImageView()
    private let titleLabel = UILabel(title: "", font: .boldSystemFont(ofSize: 20), textColor: .black, textAlignment: .left)
    private let view = UIView()
    private let button = UIButton(type: .system)
    private var initialCenter: CGPoint = CGPoint()
    private var animator: UIViewPropertyAnimator?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public static func show(){
        if let keyWindow = UIApplication.shared.getKeyWindow(), shared == nil {
            let debugView = XYDebugView()
            shared = debugView
            keyWindow.addSubview(debugView)
            debugView.frame = .init(x: .width - 100, y: .height - 300, width: 100, height: 100)
            debugView.corner(radius: 50)
        }
    }
}

extension XYDebugView {
    
    func setupContent() {
        layoutContetnt()
        backgroundColor = .random
        addPanGesture()
        button.addTap { sender in
            self.window!.addSubview(self.view)
            self.view.frame = self.frame
            self.view.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.25) {
                self.view.frame = self.superview?.bounds ?? .zero
                self.view.backgroundColor = .white
            } completion: { complete in
                if complete {
                    self.view.addTap { [weak self] sender in
                        guard let self = self else { return }
                        self.addSubview(self.view)
                        self.view.frame = self.window!.bounds
                        self.view.isUserInteractionEnabled = false
                        UIView.animate(withDuration: 0.25) {
                            self.view.frame = self.bounds
                            self.corner(radius: self.layer.cornerRadius)
                            self.view.backgroundColor = self.backgroundColor
                        }completion: { complete in
                            if complete {
                                self.view.backgroundColor = .clear
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
    
    func layoutContetnt() {
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(view)
        addSubview(button)
        
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        view.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
        
        button.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
