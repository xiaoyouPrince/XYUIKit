//
//  XYAlert.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2023/8/29.
//

import Foundation

public typealias Alert = XYAlert
public struct XYAlert {
    
    /// 弹出一个 tip 类型的 alert
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - callback: 确认按钮点击回调
    static func showTipAlert(title: String?, message: String?, okBtnTitle btnTitle: String, _ callback:@escaping ()->()) {
        showAlert(title: title, message: message, btnTitles: btnTitle) { _ in callback() }
    }
    
    /// 弹出一个弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 晓霞
    ///   - btnTitles: 底部按钮标题, 逗号分隔 egg: "cancel", "ok"
    ///   - callback: 按钮点击回调, 按标题顺序从 0 开始
    static func showAlert(title: String?, message: String?, btnTitles: String..., callback:@escaping (_ index: Int)->()) {
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
    static func showTextFiledAlert(title: String?, message: String?, configurationHandler: ((UITextField) -> Void)? = nil, btnTitles: String..., callBack: @escaping (_ text: String)->Bool) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: configurationHandler)
        
        for (_, title) in btnTitles.enumerated() {
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { action in
                let shouldDismiss = callBack(title)
                if shouldDismiss {
                    alert.dismiss(animated: true)
                }
            }))
        }
        
        UIViewController.currentVisibleVC.present(alert, animated: true)
    }
}
