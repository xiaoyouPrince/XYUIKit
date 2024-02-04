//
//  XYDatePicker.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/1/19.
//

import Foundation
import UIKit

struct XYDatePicker {
    
    /// 弹出时间选择框，让用户选择时间(yyyy-MM-dd)
    /// - Parameters:
    ///   - title: 弹框 title
    ///   - choosenDate: 当前选中的时间
    ///   - callback: 用户选择完成的时间回调
    static func chooseDate(title: String,
                           choosenDate: Date,
                           callback:@escaping (Date)->()) {
        
        let containerView = UIView()
        let bar = UILabel(title: title, font: .boldSystemFont(ofSize: 17), textColor: .black, textAlignment: .center)
        let doneBtn = UILabel(title: "完成", font: .systemFont(ofSize: 17), textColor: .xy_getColor(red: 60, green: 120, blue: 251), textAlignment: .center).boxView(top: 20, left: 20, bottom: 20)
        
        let picker = UIDatePicker(frame: CGRect.init(x: 0, y: .height - 230, width: .width, height: 230))
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "zh_CN")
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.calendar = .current
        picker.date = choosenDate
        containerView.addSubview(bar)
        containerView.addSubview(picker)
        bar.addSubview(doneBtn)
        bar.isUserInteractionEnabled = true
        doneBtn.addTap { sender in
            callback(picker.date)
            XYAlertSheetController.dissmiss()
        }
        
        bar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(44)
        }
        doneBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        picker.snp.makeConstraints { make in
            make.top.equalTo(bar.snp.bottom)
            make.height.equalTo(250)
            make.left.bottom.right.equalToSuperview()
        }
        
        XYAlertSheetController.showCustom(on: .currentVisibleVC, customContentView: containerView)
    }
}
