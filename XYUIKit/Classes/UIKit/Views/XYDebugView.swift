//
//  XYDebugView.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/2/5.
//

import UIKit

@objc public protocol XYDebugViewProtocol: NSObjectProtocol {
    
}

@objc public class XYDebugView: UIView {
    static private var shared: XYDebugView!
    private var tableView = UITableView()
    private var actions = [String]()
    private var initialCenter: CGPoint = CGPoint()
    private var animator: UIViewPropertyAnimator?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
        
        actions = ["我是默认的title"]
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
    
    @objc public static func addAction(title: String, action: @escaping ()->()) {
//        if !shared.actions.keys.contains(title) {
//            shared.actions[title] = action
//        }
    }
}

extension XYDebugView {
    
    func setupContent() {
        backgroundColor = .random
        addPanGesture()
        setAction()
    }

    func displayCustom() {
        addSubview(tableView)
        tableView.frame = .init(origin: .init(x: 0, y: .naviBar), size: .init(width: .width, height: .height - .naviBar))
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension XYDebugView : UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.actions.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = self.actions[indexPath.row]
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Toast.make("hhsdf")
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
