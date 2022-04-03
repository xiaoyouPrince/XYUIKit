//
//  AnimationViewController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/4/13.
//

import UIKit

class AnimationViewController: UIViewController {
    
    // MARK: - 外界使用
        @objc public var cancelBlock: (() -> Void)?
        @objc public var jobTitle: String!

        // MARK: - 内部控件
        var superView: UIView!
        
        var closeBtn: UIImageView!
        var bgView: UIImageView!
        var tipLabel: UILabel!
        var jobLabel: UILabel!
        var tip2Label: UILabel!
        var okBtn: UIImageView!
        
        open override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .clear
            
            buildUI()
            startLayout()
            
            self.superView.clipsToBounds = true
            jobLabel.text = "至次日24时,职位【\(jobTitle!)】"
            
            let tapclose = UITapGestureRecognizer(target: self, action: #selector(closeActioin))
            closeBtn.isUserInteractionEnabled = true
            closeBtn.addGestureRecognizer(tapclose)
            
            let tapOK = UITapGestureRecognizer(target: self, action: #selector(closeActioin))
            okBtn.isUserInteractionEnabled = true
            okBtn.addGestureRecognizer(tapOK)
            
            // layoutifneed 不能生效，用延时
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.endLayout()
                UIView.animate(withDuration: 0.25) {
                    self.superView.layoutIfNeeded()
                    self.superView.alpha = 1.0
                }
            }
        }
        
        open override var modalPresentationStyle: UIModalPresentationStyle{
            set{}
            get{
                .custom
            }
        }
        
        func buildUI() {
            
            func kHexColor(_ valueRGB:UInt) -> UIColor {
                return UIColor.init(
                    red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
                    green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
                    blue: CGFloat(valueRGB & 0x0000FF) / 255.0,
                    alpha:1
                )
            }
            
            superView = UIView()
            view.addSubview(superView)
            
            let closeImage = UIImage(named: "btn_close")
            closeBtn = UIImageView(image: closeImage)
            superView.addSubview(closeBtn)

            let starImage = UIImage(named: "alert_resume_expose")?.xy_blurImage(0.9)
            bgView = UIImageView(image: starImage)
            superView.addSubview(bgView)
            
            tipLabel = UILabel()
            tipLabel.text = "超级曝光已生效！"
            tipLabel.textColor = kHexColor(0xF7CD7A)
            tipLabel.font = UIFont.systemFont(ofSize: 18)
            tipLabel.textAlignment = .center
            tipLabel.numberOfLines = 2
            tipLabel.backgroundColor = .clear
            superView.addSubview(tipLabel)
            
            jobLabel = UILabel()
            jobLabel.text = "超级曝光已生效！"
            jobLabel.textColor = .white
            jobLabel.font = UIFont.systemFont(ofSize: 12)
            jobLabel.textAlignment = .center
            jobLabel.numberOfLines = 2
            jobLabel.backgroundColor = .clear
            superView.addSubview(jobLabel)
            
            tip2Label = UILabel()
            tip2Label.text = "将被连续10倍曝光，查看职位人数持续增长中…"
            tip2Label.textColor = .white
            tip2Label.font = UIFont.systemFont(ofSize: 12)
            tip2Label.textAlignment = .center
            tip2Label.numberOfLines = 1
            tip2Label.backgroundColor = .clear
            superView.addSubview(tip2Label)
            
            let okImage = UIImage(named: "alert_ok_btn")
            okBtn = UIImageView(image: okImage)
            self.superView.addSubview(okBtn)

        }
        
        // xib动画
        func startLayout() {
            
            self.superView.alpha = 0.01
            self.superView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
            self.superView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            closeBtn.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 0, height: 0))
            }
            bgView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 0, height: 0))
            }
            tipLabel.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 0, height: 0))
            }
            jobLabel.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 0, height: 0))
            }
            tip2Label.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 0, height: 0))
            }
            okBtn.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 0, height: 0))
            }
            
            self.view.layoutIfNeeded()
        }
        
        func endLayout() {
            self.superView.snp.remakeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            closeBtn.snp.remakeConstraints { (make) in
                make.top.equalTo(100)
                make.right.equalTo(-20)
            }
            bgView.snp.remakeConstraints { (make) in
                make.top.equalTo(187)
                make.centerX.equalToSuperview()
                make.size.equalTo(UIImage(named: "alert_resume_expose")!.size)
            }
            tipLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(bgView!.snp.top).offset(221)
                make.centerX.equalToSuperview()
            }
            jobLabel.numberOfLines = 2
            jobLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(tipLabel!.snp.bottom).offset(15)
                make.centerX.equalToSuperview()
                make.left.equalToSuperview().offset(30)
            }
            tip2Label.snp.remakeConstraints { (make) in
                make.top.equalTo(jobLabel!.snp.bottom).offset(8)
                make.centerX.equalToSuperview()
            }
            okBtn.snp.remakeConstraints { (make) in
                make.top.equalTo(tip2Label!.snp.bottom).offset(29)
                make.centerX.equalToSuperview()
            }
        }
        
        // action
        @objc func closeActioin() {
            
            let duration = 0.25
            
            UIView.animate(withDuration: duration) {
                self.superView.alpha = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.dismiss(animated: false, completion: nil)
            }
        }

}
