//
//  File.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/4/1.
//

import UIKit
import MJRefresh

protocol Refresh {
    
    func errorView(title: String) -> UIView
}




extension UIViewController: Refresh {
    func errorView(title: String) -> UIView {
        let errorView = UILabel()
        errorView.backgroundColor = .red
        errorView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        errorView.center = view.center
        errorView.text = title
        return errorView
    }
    
    func showErrorView(title: String) {
        view.addSubview(errorView(title: title))
    }
}

import XYInfomationSection
extension XYInfomationBaseViewController {

    func xy_buildUI(dataArr: [Any]) {
        
        if dataArr.count == 0 { return }
        
        self.setContentWithData(dataArr, itemConfig:{(item) in
            item.titleKey = "SwiftLearn.\(item.titleKey)"
            item.titleWidthRate = 0.5
        } , sectionConfig: nil, sectionDistance: 10, contentEdgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) { (index, cell) in
            
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
