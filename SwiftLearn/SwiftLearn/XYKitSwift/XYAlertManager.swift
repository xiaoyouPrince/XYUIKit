//
//  XYAlertManager.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/5/13.
//

import UIKit

@objc public
protocol XYAlertManagerDelegate: NSObjectProtocol {
    
    @objc optional
    func alertTitles() -> [String]
    
    @objc optional
    func showAlert(item: XYAlertItem)
}

open
class XYAlertItem: NSObject {
    var title: String?
    var index: Int = -1
    var manager: XYAlertManager?
    
    func showNext() {
        self.manager?.startShowAlert(index+1)
    }
}

open
class XYAlertManager: NSObject {
    
    weak public var delegate: XYAlertManagerDelegate?
    
    func startShowAlert(_ index: Int = 0) {
        
        // 必须有入参，获取要展示title
        guard let alertTitles = self.delegate?.alertTitles?() else {
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
        self.delegate?.showAlert?(item: alertItems[index])
    }
}

extension UIViewController: XYAlertManagerDelegate {
    public func xy_startShowAlert() {
        let mgr = XYAlertManager()
        mgr.delegate = self
        mgr.startShowAlert()
    }
}
