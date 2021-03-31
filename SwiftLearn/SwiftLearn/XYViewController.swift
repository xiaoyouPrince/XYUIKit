//
//  XYViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/3/29.
//

import UIKit
import XYInfomationSection

class XYViewController: XYInfomationBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setContentWithData(dataArr(), itemConfig: nil, sectionConfig: nil, sectionDistance: 10, contentEdgeInsets: .zero) { (index, cell) in
            
            guard let clz = NSClassFromString(cell.model.titleKey) as? UIViewController.Type else{
                return
            }
            print(clz)
            
//            let detailVC = clz.self.init()
            let detailVC = clz.init()
            
            print(detailVC)
            print("goto sub vc")
            
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
                    "titleKey": "SwiftLearn.TableViewController",
                    "value": "自定义的刷新",
                    "type": 1
                ]
            ]
        ]
        
        let a = [
            [
                "title": "自定义 loading",
                "titleKey": "UIViewController",
                "value": "去设置",
                "type": 1
            ]
        ]
        
        
        result.append(a)
        
        return result
    }
}
