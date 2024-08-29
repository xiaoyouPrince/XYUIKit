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
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.overrideUserInterfaceStyle = XYUtils.overrideUserInterfaceStyle
        colorPicker.delegate = shared
        if #available(iOS 15.0, *) {
            colorPicker.modalPresentationStyle = .formSheet
            if let sheet = colorPicker.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge =
                PresentationHelper.sharedInstance.prefersScrollingExpandsWhenScrolledToEdge
                sheet.prefersEdgeAttachedInCompactHeight =
                PresentationHelper.sharedInstance.prefersEdgeAttachedInCompactHeight
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached =
                PresentationHelper.sharedInstance.widthFollowsPreferredContentSizeWhenEdgeAttached
            }
        }
        currentVisibleVC.present(colorPicker, animated: true, completion: nil)
    }
}


@available(iOS 14.0, *)
extension XYColorPicker: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        XYColorPicker.shared.callback?(selectedColor)
    }
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        XYColorPicker.shared.callback?(selectedColor)
    }
}


@available(iOS 15.0, *)
extension UISheetPresentationController.Detent.Identifier {
    static let small = UISheetPresentationController.Detent.Identifier("small")
}

@available(iOS 15.0, *)
class PresentationHelper {
    static let sharedInstance = PresentationHelper()
    var largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier = .medium
    var prefersScrollingExpandsWhenScrolledToEdge: Bool = true
    var prefersEdgeAttachedInCompactHeight: Bool = true
    var widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false
}
