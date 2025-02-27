//
//  XYAlert.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2023/8/29.
//

import Foundation
import UIKit

public typealias Alert = XYAlert
// MARK: - 展示一个系统 alert
public struct XYAlert {
    
    /// 弹出一个 tip 类型的 alert
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - callback: 确认按钮点击回调
    public static func showTipAlert(title: String?, message: String?, okBtnTitle btnTitle: String, _ callback:@escaping ()->()) {
        showAlert(title: title, message: message, btnTitles: btnTitle) { _ in callback() }
    }
    
    /// 弹出一个弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 晓霞
    ///   - btnTitles: 底部按钮标题, 逗号分隔 egg: "cancel", "ok"
    ///   - callback: 按钮点击回调, 按标题顺序从 0 开始
    public static func showAlert(title: String?, message: String?, btnTitles: String..., callback:@escaping (_ index: Int)->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (idx, title) in btnTitles.enumerated() {
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { action in
                alert.dismiss(animated: true)
                callback(idx)
            }))
        }
        UIViewController.currentVisibleVC.present(alert, animated: true)
    }
    
    /// 弹出一个可以含有输入框的 alert
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - configurationHandler: textField 配置回调
    ///   - btnTitles: 底部要展示的按钮标题
    ///   - callBack: 用户点击按钮时候回调,返回当前用户输入内容, 内部返回 Bool 告知是否需要 dismiss alert
    public static func showTextFiledAlert(title: String?, message: String?, configurationHandlers: ((UITextField) -> Void)..., btnTitles: String..., callBack: @escaping (_ idx: Int, _ text: [String])->Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        configurationHandlers.forEach { config in
            alert.addTextField(configurationHandler: config)
        }
        
        for (idx, title) in btnTitles.enumerated() {
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { action in
                callBack(idx, alert.textFields?.map { $0.text ?? "" } ?? [])
            }))
        }
        
        UIViewController.currentVisibleVC.present(alert, animated: true)
    }
}


// MARK: - 展示一个自定义 alert

public struct XYAlertConfig {
    /// show 动画执行时长
    var animationInterval: TimeInterval = 0.125
    /// alert 展示后，其容器页面背景颜色
    var bgColor: UIColor = .black.withAlphaComponent(0.3)
    /// 是否允许背景区域的点击关闭事件
    var dismissOnTapBackground = true
    /// show 执行动画的的事务，自定义展示事务，需要在此回调用执行展示动画相关操作, 参数是页面背景视图
    var startTransaction: ((_ bgView: UIView) -> Void)?
    
    public init(animationInterval: TimeInterval = 0.125, bgColor: UIColor = .black.withAlphaComponent(0.3), dismissOnTapBackground: Bool = true, startTransaction: ( (_ bgView: UIView) -> Void)? = nil) {
        self.animationInterval = animationInterval
        self.bgColor = bgColor
        self.dismissOnTapBackground = dismissOnTapBackground
        self.startTransaction = startTransaction
    }
    
    public init() { }
}

public extension XYAlert {
    
    fileprivate class XYAlertController: UIViewController {
        let alertView: UIControl
        let config: XYAlertConfig
        
        init(alert: UIView, config: XYAlertConfig) {
            if let alertV = alert as? UIControl {
                alertView = alertV
            } else {
                let alertV = UIControl()
                alertV.addSubview(alert)
                alert.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                alertView = alertV
            }
            self.config = config
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.addSubview(alertView)
            alertView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            view.backgroundColor = .clear
            start()
        }
        
        private func start() {
            if let startTransaction = config.startTransaction {
                startTransaction(view)
            } else {
                alertView.alpha = 0.5
                alertView.transform = .init(scaleX: 0.85, y: 0.85)
                alertView.corner(radius: 15)
                UIView.animate(withDuration: config.animationInterval) {
                    self.view.backgroundColor = self.config.bgColor
                    self.alertView.alpha = 1.0
                    self.alertView.transform = .identity
                }
            }
        }
        
        private func end() {
            
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if config.dismissOnTapBackground {
                dismiss(animated: false)
            }
        }
        
        deinit {
            print("XYAlertController - deinit")
        }
    }
    
    /// 弹出一个自定义的 alert 视图
    /// - Parameter alert: 自定义 alert view, 需要自行设置宽高约束
    /// - Note: 默认效果效果会将自定义 alert 布局
    static func showCustom(_ alertView: UIView) {
        showCustom(alertView, with: .init())
    }
    
    /// 弹出一个自定义的 alert 视图
    /// - Parameter alert: 自定义 alert view, 需要自行设置宽高约束
    /// - Note: 默认效果效果会将自定义 alert 布局
    static func showCustom(_ alertView: UIView, with config: XYAlertConfig) {
        let alertVC = XYAlertController(alert: alertView, config: config)
        alertVC.modalPresentationStyle = .custom
        UIViewController.currentVisibleVC.present(alertVC, animated: false)
    }
    
    static func dismiss() {
        UIViewController.currentVisibleVC.dismiss(animated: false)
    }
}
