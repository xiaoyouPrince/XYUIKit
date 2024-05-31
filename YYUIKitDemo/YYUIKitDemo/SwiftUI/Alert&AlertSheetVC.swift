//
//  Alert&AlertSheetVC.swift
//  YYUIKitDemo
//
//  Created by 渠晓友 on 2024/5/31.
//

import SwiftUI
import YYUIKit

fileprivate let AlertTitle = "AlertTitle"
fileprivate let AlertContent = "ContentContentContentContentContentContentContentContent"

struct Alert_AlertSheetVC: View {
    var body: some View {
        
        
        List() {
            
            Section {
                Text("本页面介绍了 Alert 和 AlertSheet 工具和用法")
            }
            
            Button("Alert - 单按钮") {
                XYAlert.showAlert(title: AlertTitle, message: AlertContent, btnTitles: "Btn1") { index in
                    Toast.make("第 \(index) 个按钮点击")
                }
            }
            
            Button("Alert - 双按钮") {
                XYAlert.showAlert(title: AlertTitle, message: AlertContent, btnTitles: "Btn1", "Btn2") { index in
                    Toast.make("第 \(index) 个按钮点击")
                }
            }
            
            Button("Alert - 多按钮") {
                XYAlert.showAlert(title: AlertTitle, message: AlertContent, btnTitles: "Btn1", "Btn2", "Btn3") { index in
                    Toast.make("第 \(index) 个按钮点击")
                }
            }
            
            Button("Alert - 单输入框") {
                XYAlert.showTextFiledAlert(title: AlertTitle, message: AlertContent, configurationHandlers: { tf in
                    tf.placeholder = "输入Name"
                }, btnTitles: "OK", "Cancel") { idx, tests  in
                    Toast.make("\(idx)" + "\(tests))")
                }
            }
            Button("Alert - 双输入框") {
                XYAlert.showTextFiledAlert(title: AlertTitle, message: AlertContent, configurationHandlers: { tf in
                    tf.placeholder = "输入Name"
                }, { tf in
                    tf.placeholder = "输入PWD"
                } , btnTitles: "OK", "Cancel") { idx, tests  in
                    Toast.make("\(idx)" + "\(tests))")
                }
            }
            Button("Alert - 多输入框") {
                XYAlert.showTextFiledAlert(title: AlertTitle, message: AlertContent, configurationHandlers: { tf in
                    tf.placeholder = "输入Name"
                }, { tf in
                    tf.placeholder = "输入PWD"
                }, { tf in
                    tf.placeholder = "输入TelPhone"
                } , btnTitles: "OK", "Cancel") { idx, tests  in
                    Toast.make("\(idx)" + "\(tests))")
                }
            }
            
            Section {
                Button("AlertAheet - 默认样式") {
                    XYAlertSheetController.showDefault(on: UIViewController.currentVisibleVC, title: AlertTitle, subTitle: "subTitle: 可选", actions: ["同意","拒绝","放弃"]) { index in
                        Toast.make("第 \(index) 个按钮点击")
                    }
                }
                
                Button("AlertAheet - 默认样式") {
                    
                    let view = UIView()
                    view.backgroundColor = .random
                    view.snp.makeConstraints { make in
                        make.height.equalTo(400)
                    }
                    
                    XYAlertSheetController.showCustom(on: UIViewController.currentVisibleVC, customContentView: view).isContentAboveSafeArea = false
                }
            }
        }
    }
}

#Preview {
    Alert_AlertSheetVC()
}
