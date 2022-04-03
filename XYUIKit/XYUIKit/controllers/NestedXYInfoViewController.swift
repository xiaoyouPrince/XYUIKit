//
//  NestedXYInfoViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/7/30.
//
//  支持内嵌 XYInfomationSection 使用

import UIKit
import XYInfomationSection

class NestedXYInfoViewController: UIViewController {
    
    var addBtn: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
//        navigationController?.navigationBar.barTintColor = UIColor.green//.withAlphaComponent(0.5)
//        self.navigationController?.navigationBar.isTranslucent = false
        
//        navigationController?.navigationBar.barTintColor = .black
        
        
        reloadUI()
        
        let add = UIButton(type: .contactAdd)
        self.view.addSubview(add)
        add.addTarget(self, action: #selector(touchesBegan__), for: .touchUpInside)
        add.frame = CGRect(x: 100, y: 400, width: 50, height: 50)
        addBtn = add
    }
    
    @objc func touchesBegan__() {
        let rad = arc4random()%2 == 0 ? true : false
        navigationController?.setNavigationBarHidden(rad, animated: true)
        
        reloadUI()
        view.bringSubviewToFront(addBtn!)
    }
    
    
    func reloadUI() {
        
        XYInfomationBaseViewController.nested(inVC: self, withContentOfData: dataArr(), itemConfig: { (item) in
            item.titleWidthRate = 0.3
        }, sectionConfig: { (section) in
            
        }, sectionDistance: 10, contentEdgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) {[weak self] (index, cell) in
            
            if cell.model.titleKey == "currentTime" {
                UIPasteboard.general.string = cell.model.value
                SVProgressHUD.showSuccess(withStatus: "\(cell.model.title)粘贴到剪切版")
                return
            }

            guard let clz = NSClassFromString("XYUIKit.\(cell.model.titleKey)") as? XYCustomTimePickerViewController.Type else{
                return
            }
            let detailVC = clz.init()
            self?.present(detailVC, animated: false, completion: nil)
        }
    }
    
    deinit {
        print("\(self) - deinit")
    }
}

extension NestedXYInfoViewController {
    
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
                "title": "开始时间",
                "titleKey": "minDate",
                "placeholderValue": "yyyy-MM-dd HH:mm:ss",
                "type": 0
            ],
            [
                "title": "结束时间",
                "titleKey": "maxDate",
                "placeholderValue": "yyyy-MM-dd HH:mm:ss",
                "type": 0
            ],
            [
                "title": "默认选中时间",
                "titleKey": "chooseDate",
                "placeholderValue": "yyyy-MM-dd HH:mm:ss",
                "type": 0
            ]
        ]
        
        let b = [
            [
                "title": "用户选中时间",
                "titleKey": "XYCustomTimePickerViewController",
                "value": "去选择",
                "type": 1
            ]
        ]
        
        result.append(a)
        result.append(b)
        return result
    }
}
