//
//  ZLPushNotificationTipView.swift
//  ZLNIMComponent
//
//  Created by 渠晓友 on 2020/12/10.
//

import UIKit

class ZLPushNotificationTipView: UIView {
    
    typealias function = ()->()
    
    let contentColor = UIColor(red: CGFloat(0x09) / 255.0, green: CGFloat(0x6E) / 255.0, blue: CGFloat(0xFD) / 255.0, alpha: 1)
    var closeHandler: function?
    var openHandler: function?
    
    var bgView = UIView()
    var closeBtn = UIButton()
    var titleLabel = UILabel()
    var openBtn = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupContent()
    }
    
    init(closeHandler: (()->())? = nil, openHandler: (()->())? = nil) {
        super.init(frame: .zero)
        setupContent(closeHandler: closeHandler, openHandler: openHandler)
    }
    
    
    func setupContent(closeHandler: (()->())? = nil, openHandler: (()->())? = nil) {
        
        self.closeHandler = closeHandler
        self.openHandler = openHandler
        self.backgroundColor = UIColor.clear
        
        addSubview(bgView)
        bgView.addSubview(closeBtn)
        bgView.addSubview(titleLabel)
        bgView.addSubview(openBtn)
        
        bgView.layer.cornerRadius = 22
        bgView.backgroundColor = .white
        bgView.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        bgView.layer.shadowRadius = 6
        bgView.layer.shadowOpacity = 0.99
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        closeBtn.setTitle("×", for: .normal)
        closeBtn.setTitleColor(contentColor, for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnHandler), for: .touchUpInside)
        
        titleLabel.text = "通知被关闭，无法接受消息提醒"
        titleLabel.textColor = contentColor
        titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 12)
        
        openBtn.text = "去开启"
        openBtn.textColor = .white
        openBtn.backgroundColor = contentColor
        openBtn.font = UIFont(name: "PingFangSC-Medium", size: 10)
        openBtn.textAlignment = .center
        openBtn.layer.cornerRadius = 11
        openBtn.clipsToBounds = true
        openBtn.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openBtnHandler))
        openBtn.addGestureRecognizer(tap)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(18)
            make.size.equalTo(CGSize(width: 12, height: 12))
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(closeBtn).offset(22)
            make.centerY.equalToSuperview()
        }
        
        openBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 46, height: 22))
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    // 关闭按钮
    @objc func closeBtnHandler(){
        if let closeH = self.closeHandler {
            closeH()
        }
    }
    
    // 去开启 -> 设置页面
    @objc func openBtnHandler(){
        if let openH = self.openHandler {
            openH()
        }
    }
    
    deinit {
        print("-----deinit-----")
    }
}
