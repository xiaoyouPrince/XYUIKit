//
//  TimeViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/6/1.
//

import XYInfomationSection
import SVProgressHUD

class TimeViewController: XYInfomationBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
        
        self.setContentWithData(dataArr(), itemConfig: { (item) in
            item.titleWidthRate = 0.3
        }, sectionConfig: { (section) in
            
        }, sectionDistance: 10, contentEdgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) { (index, cell) in
            
            if cell.model.titleKey == "currentTime" {
                UIPasteboard.general.string = cell.model.value
                SVProgressHUD.showSuccess(withStatus: "\(cell.model.title)粘贴到剪切版")
                return
            }
            
            guard let clz = NSClassFromString("SwiftLearn.\(cell.model.titleKey)") as? XYCustomTimePickerViewController.Type else{
                return
            }
            let detailVC = clz.init()
            let params = self.getAllParams()[1]
            detailVC.minDate = Date.date(withFormatter: "yyyy-MM-dd HH:mm:ss", dateString: params["minDate"]!) ?? Date()
            detailVC.maxDate = Date.date(withFormatter: "yyyy-MM-dd HH:mm:ss", dateString: params["maxDate"]!) ?? Date()
            detailVC.chooseDate = Date.date(withFormatter: "yyyy-MM-dd HH:mm:ss", dateString: params["chooseDate"]!) ?? Date()
            detailVC.cancelBlock = { (choosedDate) in
                cell.model.value = choosedDate.string(withFormatter: "yyyy-MM-dd HH:mm:ss")
                let model = cell.model
                cell.model = model
            }
            self.present(detailVC, animated: false, completion: nil)
        }
        
        addFirstCellTimeRuns()
    }
    
    func addFirstCellTimeRuns() {
        let firstCell = self.contentView.subviews.first!.subviews.first!.subviews.first! as! XYInfomationCell
        
        // 添加监听,第一个时间cell每秒更新
        let timer = Timer.init(fire: Date(), interval: 1, repeats: true) { (timer) in
            firstCell.model.value = "\(Date().string(withFormatter: "yyyy-MM-dd HH:mm:ss"))"
            let model = firstCell.model
            firstCell.model = model
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func getAllParams() -> [[String: String]] {
        let sections = self.contentView.subviews.first!.subviews as! [XYInfomationSection]
        var params: [[String: String]] = []
        for section in sections {
            params.append(section.contentKeyValues as! [String: String])
        }
        return params
    }
    
    deinit {
        print("TimeViewController - deinit")
        let params = getAllParams()
        print(params)
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
