//
//  ShowAlertVC.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/5/11.
//

import UIKit

class ShowAlertVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
        
//        showSheet()
        
        xy_startShowAlert()
    }
}

// 实现show Alert 方法
extension ShowAlertVC {
    func alertTitles() -> [String] {
        return ["你","好","世","界","！"]
    }
    
    func showAlert(item: XYAlertItem) {
        if item.index == 0 { // 或者直接判断 item.title 同上面方法是对应的
            // 1. 展示，用户的回调中调用下一个，或者直接停止
            
            // 2. 直接调用下一个方法
            item.showNext()
            return
        }else{
            
        }
        
        showAlertFunc(item: item)
        print(item.title)
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


extension ShowAlertVC {
    
    func showSheet() {
        
        let actions = [
            "展示一个 alert ",
        ]
        
        let callback = {[weak self](index: Int) in
            if index >= 0 {
                
                // 展示弹框
                let jobVC = ZLJobCoordinationAlertController()
                jobVC.cancelBlock = {
                    print("------")
                }
                jobVC.topImage = UIImage(named: "job_okBtn")
                jobVC.topCons = 200
                self?.present(jobVC, animated: false, completion: nil)
                
            }else{
                UILabel.xy_showTip("用户取消了选择", self?.view)
            }
        }
        
        // 直接展示默认样式
         XYAlertSheetController.showDefault(on: self,
                                           title: "本页面实现的简单示例",
                                           subTitle: "",
                                           actions: actions, callBack: callback)
    }

}
