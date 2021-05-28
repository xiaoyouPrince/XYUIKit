//
//  ShowAlertVC.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/5/11.
//

import UIKit

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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
        
        label.font = UIFont.systemFont(ofSize: 55)
        view.addSubview(label)
        
//        showSheet()
        xy_startShowAlert()
//        XYPopView.showPopTip(.top, .zero, "dsdsdds")
        
        let bView = UIView(frame: CGRect(x: 50, y: 200, width: 245, height: 170))
        bView.backgroundColor = .white
        bView.layer.cornerRadius = 10
//        bView.clipsToBounds = true
        bView.layer.shadowColor = UIColor.gray.cgColor
        bView.layer.shadowOffset = CGSize(width: 0, height: 1)
        bView.layer.shadowOpacity = 0.5
        bView.layer.shadowRadius = 10
        view.addSubview(bView)
    }
}

// 实现show Alert 方法
extension ShowAlertVC {
    
    func alertTitles() -> [String] {
        return ["你","好","世","界","！"]
    }
    
    func showAlert(item: XYAlertItem) {
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
        // 展示弹框
//        let jobVC = ZLJobCoordinationAlertController()
//        jobVC.cancelBlock = {
//            item.showNext()
//        }
//        jobVC.title = item.title
//        jobVC.topImage = UIImage(named: "job_okBtn")
//        jobVC.topCons = 200
//        self.present(jobVC, animated: false, completion: nil)
        
        
        let jobVC = XYCustomTimePickerViewController()
        jobVC.cancelBlock = {
            item.showNext()
        }
        jobVC.title = item.title
        self.present(jobVC, animated: false, completion: nil)
        
    }
}

// 展示 XYAlertSheetController 方法
extension ShowAlertVC {
    
    func showSheet() {
        
        let actions = [
            "展示一个 alert ",
        ]
        
        let callback = {[weak self](index: Int) in
            if index >= 0 {
                
                // 展示弹框
                let jobVC = ZLJobCoordinationAlertController()
                jobVC.cancelBlock = {
                    print("------")
                }
                jobVC.topImage = UIImage(named: "job_okBtn")
                jobVC.topCons = 200
                self?.present(jobVC, animated: false, completion: nil)
                
            }else{
                UILabel.xy_showTip("用户取消了选择", self?.view)
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
