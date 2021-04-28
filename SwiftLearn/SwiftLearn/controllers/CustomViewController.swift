//
//  CustomViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/4/22.
//

import UIKit

class CustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        showErrorWechat()
        
        // 直接使用工具类方法
        UILabel.xy_showTip("Hello -ss", nil, .brown, .yellow)
        
        XYAlertSheetController.showDefault(on: self, ["111","222"]) { (index) in
            print("第\(index)个按钮点击")
        }
        
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
        ZLWechatActionSheet.show(self, "你知道吗") { (type) in
            if type == .Send{
                print("1111")
            }else if type == .Change {
                print("22222")
            }else{
                print("3333")
            }
        }
        
    //        let detail = ZLWechatActionSheet()
    //        self.present(detail, animated: false, completion: nil)
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
