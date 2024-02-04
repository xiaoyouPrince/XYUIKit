//
//  ZLWechatActionSheet.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/4/23.
//
//  交换微信前的底部弹框 sheet

import UIKit

@objc public enum ZLWechatActionSheetType: Int {
    case Send = 1
    case Change
    case Cancel
}

public typealias checkTypeBlock = ((_ clickType :ZLWechatActionSheetType) -> Void)

open class ZLWechatActionSheet: UIViewController {
    
    var contentView = UIView()
    var worningStr:String?
    var checkType:checkTypeBlock?
    @objc public class func show(_ vc: UIViewController,
                                 _ worningStr: String,
                                 _ clickType:checkTypeBlock?) {
        let view = ZLWechatActionSheet()
        vc.present(view, animated: false, completion: nil)
        view.checkType = clickType
        view.worningStr = worningStr
    }
    
    
    open override var modalPresentationStyle: UIModalPresentationStyle{
        set{}
        get{
            .custom
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        buildUI()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        start()
    }
}

extension ZLWechatActionSheet {
    
    func buildUI() {

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        view.addSubview(contentView)
        
        let titleLabel = UILabel()
        titleLabel.text = "发送微信号"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        let wxLabel = UILabel()
        wxLabel.text = "wxd308371297"
        wxLabel.textColor = .black
        wxLabel.font = UIFont.systemFont(ofSize: 15)
        wxLabel.textAlignment = .center
        contentView.addSubview(wxLabel)
        
        let warningLabel = UILabel()
        warningLabel.text = worningStr ?? "交换微信后，若存在转账/汇款/比特币/虚拟货币/投资/入股/冒充法人等涉及金钱行为，请您务必提高警惕"
        warningLabel.textColor = .lightGray
        warningLabel.font = UIFont.systemFont(ofSize: 11)
        warningLabel.textAlignment = .center
        warningLabel.numberOfLines = 0
        contentView.addSubview(warningLabel)
        
        let line1 = UIView()
        line1.backgroundColor = .groupTableViewBackground
        contentView.addSubview(line1)
        
        let sendBtn = UIButton()
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.setTitleColor(.systemBlue, for: .normal)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sendBtn.addTarget(self, action: #selector(sendBtnClick), for: .touchUpInside)
        contentView.addSubview(sendBtn)
        
        let line2 = UIView()
        line2.backgroundColor = .groupTableViewBackground
        contentView.addSubview(line2)
        
        let changebtn = UIButton()
        changebtn.setTitle("修改微信", for: .normal)
        changebtn.setTitleColor(.systemBlue, for: .normal)
        changebtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        changebtn.addTarget(self, action: #selector(changeBtnClick), for: .touchUpInside)
        contentView.addSubview(changebtn)
        
        let line3 = UIView()
        line3.backgroundColor = .groupTableViewBackground
        contentView.addSubview(line3)
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.gray, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        contentView.addSubview(cancelBtn)
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
            //make.bottom.equalToSuperview().offset(34)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        wxLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        warningLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(wxLabel.snp.bottom).offset(8)
        }
        
        line1.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(warningLabel.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        sendBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(line1.snp.bottom)
            make.height.equalTo(60)
        }
        
        line2.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(sendBtn.snp.bottom)
            make.height.equalTo(1)
        }
        
        changebtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(line2.snp.bottom)
            make.height.equalTo(60)
        }
        
        line3.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(changebtn.snp.bottom)
            make.height.equalTo(6)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(line3.snp.bottom)
            make.height.equalTo(60)
            make.bottom.equalTo(-34)
        }
        
    }
    
    @objc func sendBtnClick(){
        end(type: .Send)
    }
    
    @objc func changeBtnClick(){
        end(type: .Change)
    }
    
    @objc func cancelBtnClick(){
        end(type: .Cancel)
    }
}

// 动画
extension ZLWechatActionSheet {
    
    func start() {
        
        let isIPhoneX = UIScreen.main.bounds.size.height > 812
        contentView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            if isIPhoneX{
                make.bottom.equalToSuperview()
            }else
            {
                make.bottom.equalToSuperview().offset(34)
            }
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.view.layoutIfNeeded()
        }
    }
    
    func end(type: ZLWechatActionSheetType) {
        contentView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.view.layoutIfNeeded()
        } completion: { (finish) in
            self.dismiss(animated: false) {
                if let blk = self.checkType{
                    blk(type)
                }
            }
        }
    }
}
