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
                Button("Alert - 自定义 alert 样式") {
                    
                    let alert = UILabel()
                    alert.backgroundColor = .color(hex: 0xFF0000, dark: 0x00FF00)
                    alert.snp.makeConstraints { make in
                        make.width.equalTo(CGFloat.width - 120)
                        make.height.equalTo(CGFloat.width - 200)
                    }
                    
                    alert.numberOfLines = 0
                    alert.text = """
                    自定义 alertView， 并正确赋值宽高约束。
                    其他效果均为默认效果
                    """
                    
                    alert.isUserInteractionEnabled = true
                    alert.addTap { sender in
                        Toast.make("alert 自身的点击事件，这里执行了关闭")
                        XYAlert.dismiss()
                    }
                    
                    XYAlert.showCustom(alert)
                }
                
                Button("Alert - 自定义 alert 样式, 自定义各种属性") {
                    
                    let alert = UILabel()
                    alert.backgroundColor = .color(hex: 0xFF0000, dark: 0x00FF00)
                    alert.snp.makeConstraints { make in
                        make.width.equalTo(300)
                        make.height.equalTo(190)
                    }
                    
                    alert.numberOfLines = 0
                    alert.text = """
                    自定义 alertView， 并正确赋值宽高约束。
                    自定义弹出动画时长，背景色，允许背景点击关闭
                    默认弹出动画效果
                    """
                    
                    alert.isUserInteractionEnabled = true
                    alert.addTap { sender in
                        Toast.make("alert 内容点击")
                    }
                    
                    XYAlert.showCustom(alert, with: XYAlertConfig.init(animationInterval: 1, bgColor: .yellow.withAlphaComponent(0.5), dismissOnTapBackground: true))
                }
                
                Button("Alert - 自定义 alert 样式, 禁止背景点击关闭") {
                    
                    let alert = UILabel()
                    alert.backgroundColor = .color(hex: 0xFF0000, dark: 0x00FF00)
                    alert.snp.makeConstraints { make in
                        make.width.equalTo(300)
                        make.height.equalTo(190)
                    }
                    
                    alert.numberOfLines = 0
                    alert.text = """
                    自定义 alertView， 并正确赋值宽高约束。
                    自定义弹出效果，背景色，禁止背景点击关闭
                    自定义弹出/关闭效果
                    """
                    
                    alert.isUserInteractionEnabled = true
                    alert.addTap { sender in
                        Toast.make("alert 内容点击 - 并关闭alert")
                        XYAlert.dismiss()
                    }
                    
                    XYAlert.showCustom(alert, with: XYAlertConfig.init(dismissOnTapBackground: false, startTransaction: { bgView in
                        let alertView = alert
                        if let superView = alert.superview {
                            alertView.alpha = 0.5
                            alertView.transform = .init(scaleX: 0.85, y: 0.85)
                            alertView.corner(radius: 15)
                            superView.backgroundColor = .clear
                            UIView.animate(withDuration: 0.5) {
                                superView.superview?.backgroundColor = .yellow.withAlphaComponent(0.5)
                                alertView.alpha = 1.0
                                alertView.transform = .identity
                            }
                        }
                    }))
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
                
                Button("AlertAheet - 自定义") {
                    let view = UIView()
                    view.backgroundColor = .clear
                    
                    let contentV = UILabel()
                    contentV.text = "这是一个自定义样式，可以满足比较个性的设计"
                    contentV.textAlignment = .center
                    contentV.numberOfLines = 0
                    view.addSubview(contentV)
                    contentV.backgroundColor = .white
                    contentV.corner(radius: 20)
                    contentV.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                        make.top.equalTo(20)
                        make.left.equalTo(30)
                        make.height.equalTo(150)
                    }
                    
                    let sheet = XYAlertSheetController.showCustom(on: UIViewController.currentVisibleVC, customContentView: view)
                    //sheet.isContentAboveSafeArea = false
                    sheet.backgroundColor = .black.withAlphaComponent(0.25)
                    sheet.dismissCallback = {
                        Toast.make("dimiss - 下层")
                    }
                }
            }
        }
    }
}

#Preview {
    Alert_AlertSheetVC()
}
