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
