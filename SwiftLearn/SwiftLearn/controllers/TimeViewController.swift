//
//  TimeViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/6/1.
//

import XYInfomationSection

class TimeViewController: XYInfomationBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
        
        self.setContentWithData(dataArr(), itemConfig: { (item) in
            item.titleKey = "SwiftLearn.\(item.titleKey)"
            item.titleWidthRate = 0.5
        }, sectionConfig: { (section) in
            
        }, sectionDistance: 10, contentEdgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) { (index, cell) in
            
        }
        
        // 添加监听,第一个时间cell每秒更新
        
    }

}


extension TimeViewController {
    
    func dataArr() -> [Any] {
        var result: [[[String: Any]]] = [
            [
                [
                    "title": "当前时间",
                    "titleKey": "currentTime",
                    "value": "\(Date().string(withFormatter: "yyyy-MM-dd HH:mm:ss"))",
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
