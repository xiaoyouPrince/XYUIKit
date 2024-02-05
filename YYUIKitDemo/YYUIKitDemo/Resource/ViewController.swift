//
//  ViewController.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/2/4.
//

import UIKit
import XYInfomationSection
import YYUIKit

class ViewController: XYInfomationBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        
        
        XYDebugView.show()
    }
    
    let dataModel: [String: UIViewController.Type] =
        [
            "自定义 loading": TableViewController.self,
            "stm": ViewController2.self
        ]
    
}

extension ViewController {
    
    func buildUI() {
        title = "YYUIKit"
        view.backgroundColor = .random
        
        setupContent()
    }
    
    func setupContent() {
        setContentWithData(contentData(), itemConfig: { item in
            item.titleWidthRate = 0.5
            item.type = .choose
            item.value = " "
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 0, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) {[weak self] index, cell in
            guard let self = self else { return }
            
            Toast.make("进入: \(cell.model.title)")
            let detailVC = (cell.model.obj as! UIViewController.Type).init()
            detailVC.title = cell.model.title
            self.nav_push(detailVC, animated: true)
        }
    }
}

extension ViewController {
    
    func contentData() -> [Any] {
        var result = [Any]()
        
        var section: [[String: Any]] = []
        dataModel.keys.forEach { key in
            section.append(["title": key, "obj": dataModel[key] ?? ""])
        }
        result.append(section)
        return result
    }
}

