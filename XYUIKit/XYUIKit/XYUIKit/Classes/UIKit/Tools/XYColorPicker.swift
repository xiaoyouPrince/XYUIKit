//
//  XYColorPicker.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/1/19.
//

import Foundation
import UIKit

@available(iOS 14.0, *)
class XYColorPicker: UIViewController {
    static let shared: XYColorPicker = .init()
    private init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var callback: ((UIColor)->())?
    
    static func showColorPicker(_ callback: @escaping (UIColor)->()) {
        shared.callback = callback
        let cp = UIColorPickerViewController()
        cp.delegate = shared
        currentVisibleVC.present(cp, animated: true)
    }
    
}


@available(iOS 14.0, *)
extension XYColorPicker: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        XYColorPicker.shared.callback?(selectedColor)
    }
}
