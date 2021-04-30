//
//  CustomViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/4/22.
//

import UIKit
import SVProgressHUD

class CustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        showErrorWechat()
        
        // 直接使用工具类方法
//        UILabel.xy_showTip("Hello -ss", nil, .brown, .yellow)
        

        showSheet()
    }
    
    @objc public func showErrorWechat() {
        let label = UILabel()
        label.text = "请输入有效微信号"
        self.view.addSubview(label)
        label.sizeToFit()
        label.center = self.view.center
        label.frame.size = CGSize(width: label.frame.size.width + 15, height: label.frame.size.height + 10)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textColor = .white
        label.alpha = 0.01
        
        UIView.animate(withDuration: 0.25) {
            label.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            label.removeFromSuperview()
        }
    }

}

// 展示sheet
extension CustomViewController {
    

    func showSheet() {
        
        let actions = [
            "TYAttributeLabel 示例",
            "Label 展示简单 tip 示例",
            "展示一个顶部的tipView",
            "自定义SVProgressHUD.image",
            "ssd",
            "gtt",
            "交换微信后，若存在转账/汇款/比特币",
            "取消"
        ]
        
        let callback = {[weak self](index: Int) in
            if index >= 0 {
//                UILabel.xy_showTip(actions[index], self.view)
                if index == 0 {
                    self?.showAttrLabel()
                }else if index == 1{
                    UILabel.xy_showTip(actions[index], self?.view)
                }else if index == 2{
                    self?.showTipLabel()
                }else if index == 3{
                    
                    let image = UIImage(named: "000")
                    let image2 = UIImage(named: "ic_risk_tip_close")
                    let image3 = UIImage(named: "alert_ok_btn")
                    
                    SVProgressHUD.setDefaultStyle(.dark)
                    SVProgressHUD.setMinimumDismissTimeInterval(3)
                    SVProgressHUD.setMaximumDismissTimeInterval(3)
                    SVProgressHUD.setDefaultAnimationType(.native)
                    SVProgressHUD.setImageViewSize(CGSize.zero)
                    SVProgressHUD.setValue(image, forKeyPath: "sharedView.infoImage")
                    SVProgressHUD.setValue(image2, forKeyPath: "sharedView.successImage")
                    SVProgressHUD.setValue(image3, forKeyPath: "sharedView.errorImage")
                    SVProgressHUD.setFont(UIFont.systemFont(ofSize: 16))
                    SVProgressHUD.setCornerRadius(4)
                    
//                    SVProgressHUD.show()
//                    SVProgressHUD.show(withStatus: "sss")
                    SVProgressHUD.showError(withStatus: "error")
                    
                }
            }else{
                UILabel.xy_showTip("用户取消了选择", self?.view)
            }
        }
        
        // 直接展示默认样式
         XYAlertSheetController.showDefault(on: self,
                                           title: "本页面实现的简单示例",
                                           subTitle: "",
                                           actions: actions, callBack: callback)
        
        
        // 展示自定义 headerView
//        var actionModels = [XYAlertSheetAction]()
//        for a in actions {
//            let action = XYAlertSheetAction()
//            action.title = a
//            action.textColor = .red
//            actionModels.append(action)
//        }
//
//        let header = UIView()
//        header.backgroundColor = .red
//        // header.frame.size.height = 300
//        header.snp.makeConstraints { (make) in
//            make.height.equalTo(120)
//        }
//
//        let title = UILabel()
//        title.text = "你好"
//        title.sizeToFit()
//
//        let title2 = UILabel()
//        title2.text = "这个红色是自定义header"
//        title2.sizeToFit()
//
//        let title3 = UILabel()
//        title3.text = "只需设置height即可"
//        title3.sizeToFit()
//        header.addSubview(title)
//        header.addSubview(title2)
//        header.addSubview(title3)
//
//        title.snp.makeConstraints { (make) in
//            make.top.centerX.equalToSuperview()
//        }
//        title2.snp.makeConstraints { (make) in
//            make.top.equalTo(title.snp.bottom).offset(10)
//            make.centerX.equalToSuperview()
//        }
//        title3.snp.makeConstraints { (make) in
//            make.top.equalTo(title2.snp.bottom).offset(10)
//            make.centerX.equalToSuperview()
//        }
//
//        XYAlertSheetController.showCustom(on: self, customHeader: header, actions: actionModels, callBack: callback)
    }
}

extension CustomViewController {
    
    func showTipLabel() {
        let tip = TipView(tip: "Created by 渠晓友 on 2021/4/22Created by 渠晓友 on 2021/4/22Created by 渠晓友 on 2021/4/22Created by 渠晓友 on 2021/4/22Created by 渠晓友 on 2021/4/22")
        self.view.addSubview(tip)
//        tip.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 40)

        tip.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
    }
}

extension CustomViewController: TYAttributedLabelDelegate{
    
    func showAttrLabel() {
        
        let text = "dsagsgsag + aaaaaaaa + bbb"
        
        let label =  TYAttributedLabel()
        label.backgroundColor = UIColor.green
        label.text = text
        label.frame.size.width = 200
        label.sizeToFit()
        
        let st = TYTextStorage()
        st.textColor = .red
        st.range = (text as NSString).range(of: "bbb") as NSRange
        label.addTextStorage(st)
        
        let lt = TYLinkTextStorage()
        lt.textColor = .red
        lt.underLineStyle = CTUnderlineStyle(rawValue: 0)
        lt.range = (text as NSString).range(of: "aaaaaaaa") as NSRange
        label.addTextStorage(lt)
        
        label.delegate = self
        
        self.view.addSubview(label)
        label.frame.origin = CGPoint(x: 0, y: 250)
    }
    
    func attributedLabel(_ attributedLabel: TYAttributedLabel!, textStorageClicked textStorage: TYTextStorageProtocol!, at point: CGPoint) {
        print("---")
    }
}
