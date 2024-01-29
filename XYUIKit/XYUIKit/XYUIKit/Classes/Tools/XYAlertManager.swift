//
//  XYAlertManager.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/5/13.
//

// 一个简易的 Alert 弹框管理器，简洁易用，无侵入性。让业务组件专心写业务，职责清晰
/*
 用法介绍: 三步即可使用
 
 0. 给 VC 创建拓展，实现 XYAlertManagerDelegate 协议内两个函数【入参 & 弹框回调】
 1. 在 VC 的生命周期函数内执行 xy_startShowAlert() 【开始展示弹框】
 
 class ShowAlertVC: UIViewController {

     override func viewDidLoad() {
         super.viewDidLoad()
 
         // 通常写在 viewDidLoad 中，因为每次启动，只弹一次。当然也可以写在 viewWillAppear 中
         xy_startShowAlert()
     }
 }

 // MARK:- 一个简单完整的使用示例
 extension ShowAlertVC {
     
     func alertTitles() -> [String] {
         return ["你","好","世","界","！"]   // 数组长度即要展示弹框的个数
     }
     
     func showAlert(item: XYAlertItem) {
        // 这里可以处理是否弹出当前弹框逻辑。 item 即当前弹框对应的一个数据
        // 当前弹框不展示/展示完成，可以执行下一个弹框 item.showNext()
         
         showAlertFunc(item: item)
     }
     
     func showAlertFunc(item: XYAlertItem) {
         // 展示弹框
         let jobVC = ZLJobCoordinationAlertController()
         jobVC.cancelBlock = {
             item.showNext()
         }
         jobVC.title = item.title
         jobVC.topImage = UIImage(named: "job_okBtn")
         jobVC.topCons = 200
         self.present(jobVC, animated: false, completion: nil)
     }
 }
 
 */

import UIKit

@objc
public protocol XYAlertManagerDelegate: NSObjectProtocol {
    
    /// 要展示的弹框数组，title 是为了给每个 alert 一个名字便于识别记忆。
    @objc func alertTitles() -> [String]
    
    /// 展示弹框的回调
    /// - Parameter item: 代表了当前的弹框， item.title 是之前给alert设置的名称， item.index 是当期alert的索引
    @objc func showAlert(item: XYAlertItem)
}

@objcMembers
open class XYAlertItem: NSObject {
    public var title: String?
    public var index: Int = -1
    public var manager: XYAlertManager?
    
    @objc public func showNext() {
        self.manager?.startShowAlert(index+1)
    }
}

@objc
open class XYAlertManager: NSObject {
    
    weak public var delegate: XYAlertManagerDelegate?
    
    open func startShowAlert(_ index: Int = 0) {
        
        // 必须有入参，获取要展示title
        guard let alertTitles = self.delegate?.alertTitles() else {
            assertionFailure("请遵守XYAlertManagerDelegate协议，并实现 alertTitles 方法")
            return
        }
        
        // 越界直接返回
        if index >= alertTitles.count { return }
        
        var alertItems: [XYAlertItem] = []
        var title_index = -1
        for title in alertTitles {
            title_index += 1
            let item = XYAlertItem()
            item.title = title
            item.index = title_index
            item.manager = self
            alertItems.append(item)
        }
        
        // 调用showAlert
        self.delegate?.showAlert(item: alertItems[index])
    }
}

extension UIViewController: XYAlertManagerDelegate {
    @objc open func alertTitles() -> [String] {[]}
    
    @objc open func showAlert(item: XYAlertItem) {}
    
    @objc open func xy_startShowAlert() {
        let mgr = XYAlertManager()
        mgr.delegate = self
        mgr.startShowAlert()
    }
}
