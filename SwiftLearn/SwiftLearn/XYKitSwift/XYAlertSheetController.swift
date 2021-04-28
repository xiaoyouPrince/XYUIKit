//
//  XYAlertSheetController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/4/24.
//
//  自定义 AlertSheet 控制器，样式仿写 UIAlertController，支持内部 Action 自定义
//  使用可以专注于内容与业务，方便快捷

import UIKit

public typealias XYAlertSheetBlock = ((_ index :Int) -> Void)

open
class XYAlertSheetAction: NSObject{
    var title: String?
    var defaultHeight: CGFloat = 60
    var textColor = UIColor.blue
    var font = UIFont()
    
    /// 如果赋值，需要设置高度，优先使用 frame.size.height. 如果没有设置高度，会再次使用高度约束
    /// 如果使用 自定义view, 则忽略 title
    var customView: UIView?
    /// 如果赋值，需要设置内容高度
    var block: XYAlertSheetBlock?
}

open
class XYAlertSheetController: UIViewController {

    var contentView = UIView()
    var actions: [XYAlertSheetAction] = []
    var actionStrings: [String] = []
    var block: XYAlertSheetBlock?
    
    @objc public class func showCustom(on vc: UIViewController,
                                 _ actions: [XYAlertSheetAction],
                                 _ callBack: XYAlertSheetBlock?) {
        let alertSheet = XYAlertSheetController()
        alertSheet.block = callBack
        alertSheet.actions = actions
        vc.present(alertSheet, animated: false, completion: nil)
    }
    
    @objc public class func showDefault(on vc: UIViewController,
                                 _ actions: [String],
                                 _ callBack: XYAlertSheetBlock?) {
        let alertSheet = XYAlertSheetController()
        alertSheet.block = callBack
        alertSheet.actionStrings = actions
        vc.present(alertSheet, animated: false, completion: nil)
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
        
        if actions.count > 0 { // 纯自定义内容
            buildUI(isDefalut: false)
        }else{
            buildUI()
        }
        
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        start()
    }
}


extension XYAlertSheetController {
    
    func buildUI(isDefalut:Bool = true) {
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        view.addSubview(contentView)
        
        let titleLabel = UILabel()
        titleLabel.text = "发送微信号"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        let subTitleLabel = UILabel()
        subTitleLabel.text = "发送微信号发送微信号发送微信号发送微信号发送微信号发送微信号发送微信号发送微信号发送微信号发送微信号发送微信号发送微信号"
        subTitleLabel.textColor = .gray
        subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel.textAlignment = .center
        subTitleLabel.numberOfLines = 0
        contentView.addSubview(subTitleLabel)
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(20)
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        var lastView: UIView = subTitleLabel
        
        if isDefalut {
            var index = -1
            for actionStr in actionStrings {
                index += 1
                
                let line = UIView()
                line.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                
                let label = UILabel()
                label.text = actionStr
                label.textColor = .blue
                label.font = UIFont.systemFont(ofSize: 14)
                label.textAlignment = .center
                label.isUserInteractionEnabled = true
                label.tag = index
                let tap = UITapGestureRecognizer(target: self, action: #selector(actionClick(tap:)))
                label.addGestureRecognizer(tap)
                
                contentView.addSubview(line)
                contentView.addSubview(label)
                
                line.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    
                    if actionStr == actionStrings.first {
                        make.top.equalTo(lastView.snp.bottom).offset(20)
                    }else{
                        make.top.equalTo(lastView.snp.bottom)
                    }
                    
                    if actionStr == actionStrings.last {
                        make.height.equalTo(8)
                    }else{
                        make.height.equalTo(0.5)
                    }
                }
                
                lastView = line
                
                label.snp.makeConstraints { (make) in
                    
                    make.left.right.equalToSuperview()
                    make.top.equalTo(lastView.snp.bottom)
                    make.height.equalTo(60)
                    
                    if actionStr == actionStrings.last {
                        make.bottom.equalToSuperview().offset(-34)
                    }
                }
                lastView = label
            }
        }
        
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    @objc func actionClick(tap: UITapGestureRecognizer){
        
        if let index = tap.view?.tag {
            end(index: index)
        }
    }
}

// 动画
extension XYAlertSheetController {
    
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
    
    func end(index: Int) {
        contentView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.view.layoutIfNeeded()
        } completion: { (finish) in
            self.dismiss(animated: false) {
                if let blk = self.block {
                    blk(index)
                }
            }
        }
    }
}


