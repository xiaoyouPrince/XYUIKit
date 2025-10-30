//
//  ShowAlertVC.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/5/11.
//

import UIKit
import YYUIKit

class BView: UIView {
    override func draw(_ rect: CGRect) {
        
        let pathbg = UIBezierPath.init(rect: rect)
        UIColor.white.setFill()
        pathbg.fill()
        
        let path = UIBezierPath.init()
        path.lineWidth = 23
        path.move(to: CGPoint(x: rect.width - 100, y: 0))
        path.addArc(withCenter: CGPoint(x: rect.width - 40, y: 0), radius: 60, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi/6), clockwise: false)
        UIColor.red.setStroke()
        path.stroke()
    }
}

class ShowAlertVC: UIViewController {
    
    var label = UILabel()
    
    var alertQueue: [String]?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
        
        
//        let card = XYCards(frame: .zero)
//        card.frame = CGRect(x: 50, y: 200, width: UIScreen.main.bounds.width - 100, height: 160)
//        view.addSubview(card)
//        
//        return;
        
        
        label.text = "弹框队列: \(alertTitles().joined(separator: ",")),\n 点击重新开始弹框"
        label.font = UIFont.systemFont(ofSize: 25)
        view.addSubview(label)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.addTap {[weak self] sender in
            self?.xy_startShowAlert()
        }
        
        
        let btn = UIButton(type: .system)
        btn.setTitle("点击重设弹框队列", for: .normal)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(200)
        }
        btn.addTap { [weak self] sender in
            self?.buildAlertQueue()
            self?.label.text = "弹框队列: \(self!.alertTitles().joined(separator: ",")),\n 点击重新开始弹框"
            self?.xy_startShowAlert()
        }
        
        
        
//        showSheet()
        xy_startShowAlert()
//        XYPopView.showPopTip(.top, .zero, "dsdsdds")
        
//        let bView = UIView(frame: CGRect(x: 50, y: 200, width: 245, height: 170))
//        bView.backgroundColor = .white
//        bView.layer.cornerRadius = 10
////        bView.clipsToBounds = true
//        bView.layer.shadowColor = UIColor.gray.cgColor
//        bView.layer.shadowOffset = CGSize(width: 0, height: 1)
//        bView.layer.shadowOpacity = 0.5
//        bView.layer.shadowRadius = 10
//        view.addSubview(bView)
    }
}

extension ShowAlertVC {
    func buildAlertQueue() {
        alertQueue = randomStringArray()
    }
    func randomStringArray(count: Int = 5, length: Int = 8) -> [String] {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return (0..<count).map { _ in
            String((0..<length).map { _ in characters.randomElement()! })
        }
    }
}

// 实现show Alert 方法
extension ShowAlertVC {
    
    
    
    override func alertTitles() -> [String] {
        return alertQueue ?? ["你","好","世","界","！"]
    }
    
    override func showAlert(item: XYAlertItem) {
//        if item.index%2 != 0 { // 或者直接判断 item.title 同上面方法是对应的
//            // 1. 展示，用户的回调中调用下一个，或者直接停止
//
//            // 2. 直接调用下一个方法
//            item.showNext()
//            return
//        }else{
//
//        }
        
        showAlertFunc(item: item)
        print(item.title)
    }
    
    func showAlertFunc(item: XYAlertItem) {
        
        XYAlert.showAlert(title: item.title, message: "点击同意展示下一个,取消则终止", btnTitles: "同意", "取消") { index in
            if index == 0 {
                item.showNext()
            } else {
                Toast.make("点击取消,终止弹框")
                return
            }
        }
        
        
        
        // 展示弹框
//        let jobVC = ZLJobCoordinationAlertController()
//        jobVC.cancelBlock = {
//            item.showNext()
//        }
//        jobVC.title = item.title
//        jobVC.topImage = UIImage(named: "job_okBtn")
//        jobVC.topCons = 200
//        self.present(jobVC, animated: false, completion: nil)
        
        
//        let jobVC = XYCustomTimePickerViewController()
//        jobVC.cancelBlock = { (date) in
//            item.showNext()
//        }
//        jobVC.title = item.title
//        self.present(jobVC, animated: false, completion: nil)
        
    }
}

// 展示 XYAlertSheetController 方法
extension ShowAlertVC {
    
    func showSheet() {
        
        let actions = [
            "展示一个 alert ",
        ]
        
        let callback = {[weak self](index: Int) in
            guard let self = self else { return }
            if index >= 0 {
                
                // 展示弹框
                let jobVC = ZLJobCoordinationAlertController()
                jobVC.cancelBlock = {
                    print("------")
                }
                jobVC.topImage = UIImage(named: "job_okBtn")
                jobVC.topCons = 200
                self.present(jobVC, animated: false, completion: nil)
                
            }else{
                UILabel.xy_showTip("用户取消了选择", onView: self.view)
            }
        }
        
        // 直接展示默认样式
         XYAlertSheetController.showDefault(on: self,
                                           title: "本页面实现的简单示例",
                                           subTitle: "",
                                           actions: actions, callBack: callback)
    }

}

// 富文本
extension ShowAlertVC {
    
    func showAttrText() {
    
        let attr = NSMutableAttributedString()
        let image = UIImage(named: "im_list_newgreet_quick_answer")!
        
        let attacment = NSTextAttachment()
        attacment.image = image
        let paddingTop = label.font.lineHeight - label.font.pointSize
        attacment.bounds = CGRect(x: 0, y: -paddingTop, width: image.size.width, height: image.size.height)
        
        let attrImageStr = NSAttributedString(attachment: attacment)
        attr.append(attrImageStr)
        
        attr.append(NSAttributedString(string: " "))
        
        let lastMessageAttr = attributedStringWithText("h偶尔无法违法")!
        attr.append(lastMessageAttr)
        
        label.attributedText = attr
        label.sizeToFit()
        label.center = view.center
        
    }


    private func attributedStringWithText(_ text: String) -> NSAttributedString? {
        let attrStr : NSAttributedString = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 55),
            NSAttributedString.Key.foregroundColor : UIColor.red,
                        ])
        
        return attrStr
    }
    
}
