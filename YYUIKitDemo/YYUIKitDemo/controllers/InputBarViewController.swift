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
        ])
        
        var section2 = [[String: Any]]()
        section2.append([
            "title": "\n\n\n下面是 UIKit 下的 Demo \n 我们尽量让输入框比较低\n这样键盘弹出的时候就更能挡住了\n\n",
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
    
        return [section, section2]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KeyboardToolbarConfig.shared.showToolBar = false
    }
}

class InputBarViewController2: UIViewController {
    
    var kbInputView: KBTopInputView = KBTopInputView()
    
    private var networkReachability = NetworkReachability.shared

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .white
//        
//        networkReachability.startMonitoring()
//        
//        
//        
//        let textfield = UIView()
//        view.addSubview(textfield)
//        textfield.backgroundColor = .red
////        textfield.borderStyle = .roundedRect
//        
//        textfield.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            textfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            textfield.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
//            textfield.heightAnchor.constraint(equalToConstant: 34),
//            textfield.topAnchor.constraint(equalTo: view.topAnchor, constant: .height * 0.7)
//        ])
//        
////        KeyboardToolbarConfig.shared.showToolBar = true
//        
//        view.addTap {[weak self] sender in
//            self?.kbInputView.show()
//            _ = self?.kbInputView.becomeFirstResponder()
//        }
//    }
    
    
    
    deinit {
        Console.log("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkReachability.startMonitoring()
        setupUI()
        view.backgroundColor = .white
        
        let textfield = UITextField() //UIView()
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
        
        let textfield2 = UITextField() //UIView()
        view.addSubview(textfield2)
        textfield2.backgroundColor = .red
        textfield2.borderStyle = .roundedRect

        textfield2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textfield2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textfield2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            textfield2.heightAnchor.constraint(equalToConstant: 34),
            textfield2.topAnchor.constraint(equalTo: view.topAnchor, constant: .height * 0.5)
        ])

        KeyboardToolbarConfig.shared.showToolBar = true

//        view.addTap {[weak self] sender in
//            self?.kbInputView.show()
//            _ = self?.kbInputView.becomeFirstResponder()
//            self?.kbInputView.setShowAnchorView(textfield, callabck: {[weak self] transY in
//                print(transY)
//                self?.view.transform = CGAffineTransform(translationX: 0, y: transY)
//            })
//            self?.kbInputView.textEndEditingCallback = {
//                self?.view.transform = .identity
//            }
//        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        networkReachability.stopMonitoring()
    }
    
    private func setupUI() {
        let statusLabel = UILabel()
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        updateStatusLabel(statusLabel)
        
        NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateStatusLabel(statusLabel)
        }
    }
    
    private func updateStatusLabel(_ label: UILabel) {
        label.text = networkReachability.isConnected ? "Connected (\(networkReachability.connectionType))" : "Not Connected"
    }
}
