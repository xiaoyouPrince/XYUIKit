//
//  ViewController.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/2/4.
//

import UIKit
import XYInfomationSection
import YYUIKit
import YYImage



class ViewController: XYInfomationBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        
        DispatchQueue.once {
            XYDebugView.show(self)
            
            XYDebugView.show(forScene: "首页小⚽️", with: self)
            
            XYDebugView.show(forScene: "VIP 小球", with: self)
        }
        
    }
    
    let dataModel: [String: UIViewController.Type] =
        [
            "自定义 loading": TableViewController.self,
            "stm": ViewController2.self
        ]
    
}

extension ViewController: XYDebugViewProtocol {
    func didClickDebugview() {
        // Toast.make("Xbug按钮点击, 这里来实现自己自定义的处理吧")
    }
    
    func didClickDebugview(debugView: XYDebugView, inBounds: CGRect) {
        if debugView.currenKey == "首页小⚽️"{
//            FileSystem.default.openRecently(dir: FileSystem.sandBoxPath())
//            FileSystem.default.pushOpen(navigationVC: navigationController!)
            
            AppUtils.openFolder(withPush: navigationController!)
        }
    }
    
    func willShowDebugView(debugView: XYDebugView, inBounds: CGRect) {
        if debugView.currenKey == "首页小⚽️"{
            
            view.addSubview(debugView)
            
            let origialWH: CGFloat = 100
            debugView.frame = .init(x: .width - origialWH, y: .height - 300, width: origialWH, height: origialWH)
            debugView.corner(radius: origialWH / 2)
            
            let imageV = YYAnimatedImageView()
            imageV.frame = debugView.bounds
            imageV.image = YYImage(named: "2")
            debugView.addSubview(imageV)
            
        }else if debugView.currenKey == "VIP 小球"{
            
            view.addSubview(debugView)
            
            let origialWH: CGFloat = 100
            debugView.frame = .init(x: .width - origialWH, y: .height - 300, width: origialWH, height: origialWH)
            debugView.corner(radius: origialWH / 2)
            
            let imageV = YYAnimatedImageView()
            imageV.frame = debugView.bounds
            imageV.image = YYImage(named: "1")
            debugView.addSubview(imageV)
            
        }else{
            let origialWH: CGFloat = 100
            
            debugView.frame = .init(x: .width - origialWH, y: .height - 300, width: origialWH, height: origialWH)
            debugView.corner(radius: origialWH / 2)
            
            let imageV = YYAnimatedImageView()
            imageV.frame = debugView.bounds
            imageV.image = YYImage(named: "3")
            debugView.addSubview(imageV)
        }
        
    }
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

