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
        
        showSheet()
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
