//
//  InputBarViewController.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/6/17.
//

import UIKit
import YYUIKit
import XYInfomationSection
import SwiftUI
import XYNav

class InputBarViewController: XYInfomationBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KeyboardToolbarConfig.shared.showToolBar = true
        XYKeyboardAutoDismisser.shared.startMonitoring()
    }
    
    deinit {
        XYKeyboardAutoDismisser.shared.stopMonitoring()
    }
    
    func buildUI() {
        title = "YYUIKit"
        view.backgroundColor = .random
        
        setupContent()
    }
    
    func setupContent() {
        setContentWithData(contentData(), itemConfig: { item in
            item.titleWidthRate = 0.7
            item.value = " "
            if item.title.contains("请输入") {
                item.titleWidthRate = 0.4
                item.value = ""
            }
            if item.title.contains("请输入自我简介") {
                item.cellHeight = 120
            }
        }, sectionConfig: { section in
            section.corner(radius: 5)
        }, sectionDistance: 20, contentEdgeInsets: .init(top: 10, left: 10, bottom: 0, right: 10)) {[weak self] index, cell in
            guard let self = self else { return }
            
            if let vcType = cell.model.obj as? UIViewController.Type {
                let detailVC = vcType.init()
                detailVC.title = cell.model.title
                self.nav_push(detailVC, animated: true)
                XYNavigationController.showClassNameByDefault(true)
            } else if let view = cell.model.obj as? (any View) {
                let detailVC = UIHostingController(rootView: AnyView(view))
                detailVC.title = cell.model.title
                self.nav_push(detailVC, animated: true)
                XYNavigationController.showClassNameByDefault(false)
            }
        }
    }
    
    func contentData() -> [Any] {
        var section = [[String: Any]]()
        
        section.append([
            "title": "点我查看 SwiftUI.Demo",
            "type": XYInfoCellType.choose.rawValue,
            "obj": KeyboardMonitor_InPutBar()
        ])
        
        var section1 = [[String: Any]]()
        section1.append([
            "title": "这是一个键盘上方输入框.Demo",
            "type": XYInfoCellType.choose.rawValue,
            "obj": InputBarViewController2.self
        ])
        
        var section2 = [[String: Any]]()
        section2.append([
            "title": "下面是 UIKit 下的 Demo \n 我们尽量让输入框比较低\n这样键盘弹出的时候就更能挡住了",
            "type": XYInfoCellType.tip.rawValue,
            "backgroundColor": UIColor.clear
        ])
        section2.append([
            "title": "请输入姓名",
            "type": XYInfoCellType.input.rawValue,
        ])
        section2.append([
            "title": "请输入学校名称",
            "type": XYInfoCellType.input.rawValue,
        ])
        section2.append([
            "title": "请输入自我简介",
            "type": XYInfoCellType.textView.rawValue,
        ])
    
        return [section, section1, section2]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KeyboardToolbarConfig.shared.showToolBar = false
    }
}

class InputBarViewController2: UIViewController {
    
    var kbInputView: KBTopInputView = KBTopInputView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        KeyboardToolbarConfig.shared.showToolBar = false
        
        let textfield = UIView()
        view.addSubview(textfield)
        textfield.backgroundColor = .red
//        textfield.borderStyle = .roundedRect
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textfield.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            textfield.heightAnchor.constraint(equalToConstant: 34),
            textfield.topAnchor.constraint(equalTo: view.topAnchor, constant: .height * 0.7)
        ])
        
        view.addTap {[weak self] sender in
            self?.kbInputView.show()
            _ = self?.kbInputView.becomeFirstResponder()
        }
    }
    
    deinit {
        Console.log("deinit")
    }
}
