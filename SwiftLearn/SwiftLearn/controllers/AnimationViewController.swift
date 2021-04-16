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
    @IBOutlet weak var superView: UIView!
    
    @IBOutlet weak var closeBtn: UIImageView!
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var tip2Label: UILabel!
    @IBOutlet weak var okBtn: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.superView.clipsToBounds = true
        
        startLayout()
        
        jobLabel.text = "至次日24时,职位【\(jobTitle!)】"
        
        let tapclose = UITapGestureRecognizer(target: self, action: #selector(closeActioin))
        closeBtn.isUserInteractionEnabled = true
        closeBtn.addGestureRecognizer(tapclose)
        
        let tapOK = UITapGestureRecognizer(target: self, action: #selector(closeActioin))
        okBtn.isUserInteractionEnabled = true
        okBtn.addGestureRecognizer(tapOK)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        endLayout()
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            self.superView.alpha = 1.0
        }
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle{
        set{}
        get{
            .custom
        }
    }
    
    // xib动画
    func startLayout() {
        
        self.superView.alpha = 0.1
        self.superView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        self.superView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 0, height: 0))
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


extension AnimationViewController {
    
//    var superView = UIView(frame: .zero)
//    var subView = UIView(frame: .zero)
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.addSubview(superView)
//        superView.backgroundColor = .red
//        superView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.size.equalTo(CGSize(width: 0, height: 0))
//        }
//
//        superView.addSubview(subView)
//        subView.backgroundColor = .green
//        subView.snp.makeConstraints { (make) in
//            make.edges.equalTo(UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40))
//            make.size.equalTo(CGSize(width: 0, height: 0))
//        }
//
//        view.backgroundColor = .white
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//
//        superView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//
//        UIView.animate(withDuration: 0.25) {
//            self.view.layoutIfNeeded()
//        }
//
//    }
}
