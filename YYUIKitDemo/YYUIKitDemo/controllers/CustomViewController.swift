////
////  CustomViewController.swift
////  SwiftLearn
////
////  Created by 渠晓友 on 2021/4/22.
////
//
//import UIKit
//import YYUIKit
//
//class CustomViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.groupTableViewBackground
//        
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////        showErrorWechat()
//        
//        // 直接使用工具类方法
////        UILabel.xy_showTip("Hello -ss", nil, .brown, .yellow)
//        
//
//        showSheet()
//    }
//    
//    @objc public func showErrorWechat() {
//        let label = UILabel()
//        label.text = "请输入有效微信号"
//        self.view.addSubview(label)
//        label.sizeToFit()
//        label.center = self.view.center
//        label.frame.size = CGSize(width: label.frame.size.width + 15, height: label.frame.size.height + 10)
//        label.backgroundColor = UIColor.black.withAlphaComponent(0.85)
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.layer.cornerRadius = 5
//        label.clipsToBounds = true
//        label.textColor = .white
//        label.alpha = 0.01
//        
//        UIView.animate(withDuration: 0.25) {
//            label.alpha = 1
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            label.removeFromSuperview()
//        }
//    }
//
//}
//
//// 展示sheet
//extension CustomViewController {
//    
//    func svpressHUDConfig() {
//    
//        SVProgressHUD.setMinimumDismissTimeInterval(3)
//        SVProgressHUD.setMaximumDismissTimeInterval(3)
//        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 16))
//        SVProgressHUD.setCornerRadius(4)
//        SVProgressHUD.setShouldTintImages(false)
//
//        let color = UIColor.xy_getColor(red: 13, green: 82, blue: 252)
//        
//        SVProgressHUD.setDefaultStyle(.custom)
//        SVProgressHUD.setForegroundColor(color)
//        
//        let ringThick: CGFloat = 5
//        let ringRadius: CGFloat = 3
//        let NoTextRadius: CGFloat = 10
//        
//        SVProgressHUD.setRingThickness(ringThick)
//        SVProgressHUD.setRingRadius(ringRadius)
//        SVProgressHUD.setRingNoTextRadius(NoTextRadius)
//        
//        let image = UIImage(named: "000")!
//        let image2 = UIImage(named: "ic_risk_tip_close")!
//        let image3 = UIImage(named: "alert_ok_btn")!
//        
//        SVProgressHUD.setInfoImage(image.withRenderingMode(.alwaysOriginal))
//        SVProgressHUD.setSuccessImage(image2.withRenderingMode(.alwaysOriginal))
//        SVProgressHUD.setErrorImage(image3.withRenderingMode(.alwaysOriginal))
//    }
//
//    func showSheet() {
//        
//        class ItemView: UIView {
//            
//            let title: String
//
//            private let iconView = UIImageView()
//            private let titleLabel = UILabel()
//            private let tipIcon = UIImageView()
//            private let callback: ((ItemView) -> ())?
//            
//            /// 快速创建一个 item
//            /// - Parameters:
//            ///   - icon: icon
//            ///   - title: title
//            ///   - tip: tip
//            ///   - callback: 点击回调
//            init(icon: String, title: String, tip: String?, callback: @escaping (ItemView) -> ()) {
//                self.title = title
//                self.callback = callback
//                super.init(frame: .zero)
//                iconView.image = UIImage(named: icon)
//                titleLabel.text = title
//                if let tip = tip {
//                    tipIcon.image = UIImage(named: tip)
//                }
//                
//                addSubview(iconView)
//                addSubview(titleLabel)
//                addSubview(tipIcon)
//                
//                iconView.snp.makeConstraints { make in
//                    make.top.equalToSuperview()
//                    make.centerX.equalToSuperview()
//                    make.size.equalTo(CGSize(width: 62, height: 62))
//                }
//                
//                titleLabel.snp.makeConstraints { make in
//                    make.top.equalTo(iconView.snp.bottom).offset(8)
//                    make.centerX.equalTo(iconView)
//                }
//                
//                tipIcon.snp.makeConstraints { make in
//                    make.left.equalTo(iconView.snp.centerX)
//                    make.centerY.equalTo(iconView.snp.top)
//                }
//                
//                let tap = UITapGestureRecognizer(target: self, action: #selector(click))
//                addGestureRecognizer(tap)
//            }
//            
//            required init?(coder: NSCoder) {
//                fatalError("init(coder:) has not been implemented")
//            }
//            
//            @objc func click(){
//                if let cb = callback {
//                    cb(self)
//                }
//            }
//        }
//        
//        let myView = UIButton()
//        myView.backgroundColor = .white
//        myView.snp.makeConstraints { make in
//            make.height.equalTo(200)
//        }
//        
//        let label = UILabel()
//        label.text = "请选择面试方式"
//        label.sizeToFit()
//        myView.addSubview(label)
//        
//        let close = UIButton(type: .system)
//        close.setImage(UIImage(named: "ic_risk_tip_close"), for: .normal)
//        close.tintColor = UIColor.random
//        close.sizeToFit()
//        myView.addSubview(close)
//        
//        label.snp.makeConstraints { make in
//            make.left.equalTo(16)
//            make.top.equalTo(28)
//        }
//        
//        close.snp.makeConstraints { make in
//            make.top.equalTo(15)
//            make.right.equalToSuperview().offset(-15)
//        }
//        
//        let item = ItemView(icon: "ic_sheet_0", title: "现场面试", tip: "ic_risk_tip_close") { item in
//            UILabel.xy_showTip(item.title, onView: self.view)
//        }
//        let item2 = ItemView(icon: "ic_sheet_0", title: "视频面试", tip: "ic_risk_tip_close") { item in
//            UILabel.xy_showTip(item.title, onView: self.view)
//        }
//        
//        myView.addSubview(item)
//        myView.addSubview(item2)
//        item.snp.makeConstraints { make in
//            make.top.equalTo(86)
//            make.centerX.equalToSuperview().multipliedBy(0.5)
//            make.width.equalToSuperview().multipliedBy(0.5)
//            make.height.equalTo(90)
//        }
//        item2.snp.makeConstraints { make in
//            make.top.equalTo(item)
//            make.centerX.equalToSuperview().multipliedBy(1.5)
//            make.width.equalTo(item)
//            make.height.equalTo(item)
//        }
//        
//        XYAlertSheetController.showCustom(on: self, customContentView: myView).isBackClickCancelEnable = true
//        
//        return
//        
//        let actions = [
//            "TYAttributeLabel 示例",
//            "Label 展示简单 tip 示例",
//            "展示一个顶部的tipView",
//            "自定义SVProgressHUD.image - loding",
//            "自定义SVProgressHUD.image - success",
//            "自定义SVProgressHUD.image - error",
//            "自定义SVProgressHUD.image - info",
//            "自定义SVProgressHUD.image - progress",
//            "取消"
//        ]
//        
//        let callback = {[weak self](index: Int) in
//            guard let self = self else { return  }
//            if index >= 0 {
////                UILabel.xy_showTip(actions[index], self.view)
//                if index == 0 {
//                    self.showAttrLabel()
//                }else if index == 1{
//                    UILabel.xy_showTip(actions[index], onView: self.view)
//                }else if index == 2{
//                    self.showTipLabel()
//                }else if index == 3{
//                    self.svpressHUDConfig()
//                    SVProgressHUD.show()
//                }else if index == 4{
//                    self.svpressHUDConfig()
//                    SVProgressHUD.showSuccess(withStatus: "陈功能")
//                }
//                else if index == 5{
//                    self.svpressHUDConfig()
//                    SVProgressHUD.showError(withStatus: "失败")
//                }
//                else if index == 6{
//                    self.svpressHUDConfig()
//                    SVProgressHUD.showInfo(withStatus: "info")
//                }else if index == 7{
//                    self.svpressHUDConfig()
//                    
//                    var progress: Float = 0.0
//                    for i in 1...100 {
//                        DispatchQueue.global().sync {
//                            progress = ((Float)(i)) / 100.0
//                            SVProgressHUD.showProgress(progress)
//                        }
//                    }
//                }else if index == 8 {
//                    
//                }
//            }else{
//                UILabel.xy_showTip("用户取消了选择", onView: self.view)
//            }
//        }
//        
//        // 直接展示默认样式
//         XYAlertSheetController.showDefault(on: self,
//                                           title: "本页面实现的简单示例",
//                                           subTitle: "",
//                                           actions: actions, callBack: callback)
//        
//        
//        // 展示自定义 headerView
////        var actionModels = [XYAlertSheetAction]()
////        for a in actions {
////            let action = XYAlertSheetAction()
////            action.title = a
////            action.textColor = .red
////            actionModels.append(action)
////        }
////
////        let header = UIView()
////        header.backgroundColor = .red
////        // header.frame.size.height = 300
////        header.snp.makeConstraints { (make) in
////            make.height.equalTo(120)
////        }
////
////        let title = UILabel()
////        title.text = "你好"
////        title.sizeToFit()
////
////        let title2 = UILabel()
////        title2.text = "这个红色是自定义header"
////        title2.sizeToFit()
////
////        let title3 = UILabel()
////        title3.text = "只需设置height即可"
////        title3.sizeToFit()
////        header.addSubview(title)
////        header.addSubview(title2)
////        header.addSubview(title3)
////
////        title.snp.makeConstraints { (make) in
////            make.top.centerX.equalToSuperview()
////        }
////        title2.snp.makeConstraints { (make) in
////            make.top.equalTo(title.snp.bottom).offset(10)
////            make.centerX.equalToSuperview()
////        }
////        title3.snp.makeConstraints { (make) in
////            make.top.equalTo(title2.snp.bottom).offset(10)
////            make.centerX.equalToSuperview()
////        }
////
////        XYAlertSheetController.showCustom(on: self, customHeader: header, actions: actionModels, callBack: callback)
//    }
//}
//
//extension CustomViewController {
//    
//    func showTipLabel() {
//        let tip = TipView(tip: "Created by 渠晓友 on 2021/4/22Created by 渠晓友 on 2021/4/22Created by 渠晓友 on 2021/4/22Created by 渠晓友 on 2021/4/22Created by 渠晓友 on 2021/4/22")
//        self.view.addSubview(tip)
////        tip.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 40)
//
//        tip.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.top.equalToSuperview().offset(100)
//        }
//    }
//}
//
//extension CustomViewController: TYAttributedLabelDelegate{
//    
//    func showAttrLabel() {
//        
//        let text = "dsagsgsag + aaaaaaaa + bbb"
//        
//        let label =  TYAttributedLabel()
//        label.backgroundColor = UIColor.green
//        label.text = text
//        label.frame.size.width = 200
//        label.sizeToFit()
//        
//        let st = TYTextStorage()
//        st.textColor = .red
//        st.range = (text as NSString).range(of: "bbb") as NSRange
//        label.addTextStorage(st)
//        
//        let lt = TYLinkTextStorage()
//        lt.textColor = .red
//        lt.underLineStyle = CTUnderlineStyle(rawValue: 0)
//        lt.range = (text as NSString).range(of: "aaaaaaaa") as NSRange
//        label.addTextStorage(lt)
//        
//        label.delegate = self
//        
//        self.view.addSubview(label)
//        label.frame.origin = CGPoint(x: 0, y: 250)
//    }
//    
//    func attributedLabel(_ attributedLabel: TYAttributedLabel!, textStorageClicked textStorage: TYTextStorageProtocol!, at point: CGPoint) {
//        print("---")
//    }
//}
