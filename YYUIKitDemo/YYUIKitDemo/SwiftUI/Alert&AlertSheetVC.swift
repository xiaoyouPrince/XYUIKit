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
                
                Button("同上(pad 监听横竖屏适配高度)") {
                    
                    let view = UIView()
                    view.backgroundColor = .random
                    view.snp.makeConstraints { make in
                        make.height.equalTo(400)
                    }
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        if UIDevice.current.isLandscape {
                            view.snp.updateConstraints { make in
                                make.height.equalTo(200)
                            }
                        }else {
                            view.snp.updateConstraints { make in
                                make.height.equalTo(400)
                            }
                        }
                    }
                    
                    let sheet = XYAlertSheetController.showCustom(on: UIViewController.currentVisibleVC, customContentView: view)
                    sheet.isContentAboveSafeArea = false
                    sheet.dismissCallback = {
                        Toast.make("dimiss")
                    }
                    
                    sheet.gestureDismissCallback = { distance, ratio in
                        Toast.make("distance: \(distance) \nratio: \(ratio)")
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { noti in
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            if UIDevice.current.isLandscape {
                                view.snp.updateConstraints { make in
                                    make.height.equalTo(200)
                                }
                            }else {
                                view.snp.updateConstraints { make in
                                    make.height.equalTo(400)
                                }
                            }
                        }
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
                
                
                Button("AlertAheet - 一个自定义时间选择器") {
                    let timePicker = TimePickerView()
                    //timePicker.frame = CGRect(x: 0, y: 0, width: .width, height: 260) // 设置合适的高度
                    timePicker.snp.makeConstraints { make in
                        make.height.equalTo(300)
                    }
                    timePicker.setSelectedTime(hour: 14, minute: 10) // 设置为14:30
                    timePicker.onTimeSelected = { selectedTime in
                        print("选择的时间是: \(selectedTime)") // 格式为 "HH:mm"
                        Toast.make("选择的时间是: \(selectedTime)")
                        //                        XYAlertSheetController.dissmiss()
                        
                        // 创建自定义的 view
                        if let rootVC = UIViewController.currentVisibleVC {
                            let vc = UIHostingController(rootView: SearchBackgroundView(parentVC: rootVC))
                            rootVC.addChild(vc)
                            rootVC.view.addSubview(vc.view)
                            vc.view.snp.makeConstraints { make in
                                make.edges.equalToSuperview().inset(1)
                            }
                        }
                    }
                    
                    let sheet = XYAlertSheetController.showCustom(on: UIViewController.currentVisibleVC, customContentView: timePicker)
                    //sheet.isContentAboveSafeArea = false
                    sheet.backgroundColor = .black.withAlphaComponent(0.25)
                    //                    sheet.dismissCallback = {
                    //                        Toast.make("dimiss - 下层")
                    //                    }
                }
            }
            
        }
    }
}

#Preview {
    Alert_AlertSheetVC()
}




// 背景图的搜索功能 - since v2.36
struct SearchBackgroundView: View {
    /// 所处的容器控制器
    let parentVC: UIViewController
    @State var searchText: String = ""
    
    @State var searchResult: String = ""
    
    
    var body: some View {
//        Text("我是搜索页面")
//            .onTapGesture {
//                
//                Toast.make("点击关闭")
//                parentVC.children.last?.view.removeFromSuperview()
//                parentVC.children.last?.removeFromParent()
//            }
        
        VStack {
            SearchBar(text: $searchText) { keyWord in
                Toast.make("用户点击搜索 \(keyWord)")
                // 搜索
                let count = arc4random() % 30
                searchResult = "\(count)"
                
            } onCancel: {
                Toast.make("点击关闭")
                parentVC.children.last?.view.removeFromSuperview()
                parentVC.children.last?.removeFromParent()
            }
            
            
            CustomGridView(columnCount: 3, itemsCount: searchResult.intValue) { index in
                Text("index \(index)")
            }
        }
        
    }
}

import SwiftUI

@available(iOS 15.0, *)
struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    let onSearch: (_ keyWord: String) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("搜索", text: $text)
                    .font(.system(size: 14))
                    .focused($isFocused)
                    .foregroundColor(.primary)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .submitLabel(.search)
                    .onSubmit {
                        onSearch(text)
                    }

                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(10)
            .background(Color(UIColor.xy_getColor(hex: 0xF7F9FA)))
            .cornerRadius(10)
            
            Button("取消搜索") {
                text = ""
                isFocused = false
                hideKeyboard()
                onCancel()
            }
            .font(.system(size: 14))
            .foregroundColor(Color(UIColor.xy_getColor(hex: 0x333333)))
            .transition(.move(edge: .trailing))
            .animation(.default, value: isFocused)
        }
        .padding(.horizontal)
    }
}

#Preview {
    StatefulPreviewWrapper("") {
        SearchBar(text: $0) { keyWord in
            Toast.make("用户点击搜索 \(keyWord)")
        } onCancel: {
            Toast.make("点击关闭")
        }
    }
}

// 这个辅助函数用于隐藏键盘
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// 用于预览时支持 @Binding 的工具
struct StatefulPreviewWrapper<Value: Equatable>: View {
    @State var value: Value
    var content: (Binding<Value>) -> AnyView

    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> some View) {
        self._value = State(initialValue: initialValue)
        self.content = { binding in AnyView(content(binding)) }
    }

    var body: some View {
        content($value)
    }
}

// -----------

import SwiftUI

struct CustomGridView<Content: View>: View {
    let columnCount: Int
    let itemsCount: Int
    let content: (_ index: Int) -> Content
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 10), count: columnCount)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<itemsCount, id: \.self) { index in
                    content(index)
                }
            }
            .padding()
        }
    }
}

#Preview {
    CustomGridView(columnCount: 3, itemsCount: 30) { index in
        Text("index \(index)")
    }
}

