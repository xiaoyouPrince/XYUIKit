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
    
    var nameSpase: String {
        let man = UIApplication.shared.delegate!.description
        let start = man.index(after: man.startIndex)
        let end = man.firstIndex(of: ".")!
        let nameSpace = man[start..<end]
        return String(nameSpace)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        
        let nameSpase = nameSpase
        
        
//        self.navigationController?.navigationBar.isTranslucent = false
        
        
//        let label = UILabel()
//        label.text = "import XYInfomationSectionimport XYInfomationSectionimport XYInfomationSectionimport XYInfomationSectionimport XYInfomationSectionimport XYInfomationSectionimport XYInfomationSectionimport XYInfomationSectionimport XYInfomationSectionimport XYInfomationSection"
//        label.numberOfLines = 0
//        
//        view.addSubview(label)
//        label.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(100)
//            make.left.equalToSuperview().offset(30)
//            make.right.equalToSuperview().offset(-30)
//        }
//        
//        print("直接拿height",label.frame.height)
//        
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
//        print("layout后height",label.frame.height)
//        
//        label.sizeToFit()
//        print("layout后height",label.frame.height)
//        
//        return;
        
        self.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.scrollView.mj_header?.endRefreshing()
            }
        })
        
        self.setContentWithData(dataArr(), itemConfig:{(item) in
            item.titleKey = "\(nameSpase).\(item.titleKey)"
            item.titleWidthRate = 0.5
        } , sectionConfig: nil, sectionDistance: 10, contentEdgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) { (index, cell) in
            
            guard let clz = NSClassFromString(cell.model.titleKey) as? UIViewController.Type else{
                return
            }
            print(clz)
            
            if clz.description() == "\(nameSpase).ViewController" {
                
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
            detailVC.title = cell.model.title
            detailVC.xy_popGestureRatio = 0.3
            
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
        
        print("".length())
        print("1".length())
        print("12".length())
        print("sdf".length())
        print("1ddg".length())
        print("你好".length())
        print("你好123😆".length())
        
    }
}


extension XYViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 15.0, *) {
            let app = UITabBarAppearance()
            tabBarController?.tabBar.scrollEdgeAppearance = app
        } else {
            // Fallback on earlier versions
        }
        
    }
    
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
        
        let b = [
            [
                "title": "内嵌的 XYInfomationVC",
                "titleKey": "NestedXYInfoViewController",
                "value": "去查看",
                "type": 1
            ],
            [
                "title": "页面绘制",
                "titleKey": "CapatureViewController",
                "value": "去查看",
                "type": 1
            ],
            [
                "title": "消息输入框",
//                "titleKey": "ListViewController",
                //"titleKey": "XYRefreshTableViewController",
                "titleKey": "IMViewController",
                "value": "去查看",
                "type": 1
            ]
        ]
        
        
        result.append(a)
        result.append(b)
        
        return result
    }
}
