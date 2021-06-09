//
//  XYViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/3/29.
//

import UIKit
import XYInfomationSection
import MJRefresh

class XYViewController: XYInfomationBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .groupTableViewBackground
        
        self.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.scrollView.mj_header?.endRefreshing()
            }
        })
        
        self.setContentWithData(dataArr(), itemConfig:{(item) in
            item.titleKey = "SwiftLearn.\(item.titleKey)"
            item.titleWidthRate = 0.5
        } , sectionConfig: nil, sectionDistance: 10, contentEdgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) { (index, cell) in
            
            guard let clz = NSClassFromString(cell.model.titleKey) as? UIViewController.Type else{
                return
            }
            print(clz)
            
            if clz.description() == "SwiftLearn.ViewController" {
                
                if #available(iOS 13.0, *) {
                    let detailVC = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(identifier: "100")
                    self.navigationController?.pushViewController(detailVC, animated: true)
                } else {
                    // Fallback on earlier versions
                }
                
                return
            }
            
//            let detailVC = clz.self.init()
            let detailVC = clz.init()
            
            print(detailVC)
            print("goto sub vc")
            
            if let aniVC = detailVC as? AnimationViewController { // 判断 变量是不是某确定类型的子类。 类似 OC 中 isKindOfClass
                aniVC.jobTitle = "去你去你妹的去你妹的去你妹的去你妹的去你妹的去你妹的的"
                self.present(detailVC, animated: false) {
                }
                return
            }
            
            if let nav = self.navigationController {
                nav.pushViewController(detailVC, animated: true)
            }else{
                self.present(detailVC, animated: true) {
                    print("present success")
                }
            }
        }
    }
}


extension XYViewController {
    
    func dataArr() -> [Any] {
        var result: [[[String: Any]]] = [
            [
                [
                    "title": "自定义 loading",
                    "titleKey": "TableViewController",
                    "value": "自定义的刷新",
                    "type": 1
                ],
                [
                    "title": "原始 ViewController",
                    "titleKey": "ViewController",
                    "value": "去设置",
                    "type": 1
                ],
                [
                    "title": "发送邮件",
                    "titleKey": "MailViewController",
                    "value": "",
                    "type": 1
                ]
            ]
        ]
        
        let a = [
            [
                "title": "自定义 loading",
                "titleKey": "AnimationViewController",
                "value": "去设置",
                "type": 1
            ],
            [
                "title": "展示自定义视图",
                "titleKey": "CustomViewController",
                "value": "",
                "type": 1
            ],
            [
                "title": "自定义弹框组件",
                "titleKey": "ShowAlertVC",
                "value": "",
                "type": 1
            ],
            [
                "title": "时间相关测试",
                "titleKey": "TimeViewController",
                "value": "",
                "type": 1
            ]
        ]
        
        
        result.append(a)
        
        return result
    }
}
