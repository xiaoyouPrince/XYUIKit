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
                
                Button("AlertAheet - 自定义样式(手势下滑)") {
                    
                    let view = UIView()
                    view.backgroundColor = .random
                    view.snp.makeConstraints { make in
                        make.height.equalTo(400)
                    }
                    
                    let sheet = XYAlertSheetController.showCustom(on: UIViewController.currentVisibleVC, customContentView: view)
                    sheet.isContentAboveSafeArea = false
                    sheet.dismissCallback = {
                        Toast.make("dimiss")
                    }
                    
                    sheet.gestureDismissCallback = { distance, ratio in
                        Toast.make("distance: \(distance) \nratio: \(ratio)")
                    }
                }
                
                Button("AlertAheet - 自定义样式(关闭手势)") {
                    
                    let view = UIView()
                    view.backgroundColor = .random
                    view.snp.makeConstraints { make in
                        make.height.equalTo(400)
                    }
                    
                    let sheet = XYAlertSheetController.showCustom(on: UIViewController.currentVisibleVC, customContentView: view)
                    sheet.isContentAboveSafeArea = false
                    sheet.allowGestureDismiss = false
                    sheet.dismissCallback = {
                        Toast.make("dimiss")
                    }
                }
                
                Button("AlertAheet - 多个 alertSheet") {
                    
                    let view = UIView()
                    view.backgroundColor = .random
                    view.snp.makeConstraints { make in
                        make.height.equalTo(400)
                    }
                    
                    let sheet = XYAlertSheetController.showCustom(on: UIViewController.currentVisibleVC, customContentView: view)
                    sheet.isContentAboveSafeArea = false
                    sheet.dismissCallback = {
                        Toast.make("dimiss - 下层")
                    }
                    
                    let view2 = UIView()
                    view2.backgroundColor = .random
                    let txt = UILabel(title: "点我关闭上层 alertSheet", font: .boldSystemFont(ofSize: 20), textColor: .red, textAlignment: .center)
                    view2.addSubview(txt)
                    txt.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                    view2.snp.makeConstraints { make in
                        make.height.equalTo(230)
                    }
                    
                    
                    let sheet2 = XYAlertSheetController.showCustom(on: UIViewController.currentVisibleVC, customContentView: view2)
                    sheet2.isContentAboveSafeArea = false
                    sheet2.dismissCallback = {
                        Toast.make("dimiss - 上层")
                    }
                    
                    view2.addTap {[weak sheet2] sender in
                        sheet2?.dissmiss()
                    }
                }
            }
        }
    }
}

#Preview {
    Alert_AlertSheetVC()
}
