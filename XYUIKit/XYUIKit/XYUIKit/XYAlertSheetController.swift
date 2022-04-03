//
//  XYAlertSheetController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/4/24.
//
//  自定义 AlertSheet 控制器，样式仿写 UIAlertController，
//  1. 支持内部 HeaderView 自定义,需指定 headerView.frame.size.height 或高度约束
//  2. 支持内部 Action 自定义
//  3. 使用可以专注于内容与业务，方便快捷

/**
结构
 
 -------------
 |   headerview     |   如果自定义需设置 frame.size.height 或者高度约束
 -------------
 |   actions ···        |
 -------------
 |   cancelBtn       |
 -------------
 
 */

import UIKit

public typealias XYAlertSheetBlock = ((_ index :Int) -> Void)

open
class XYAlertSheetAction: NSObject{
    var title: String?
    var defaultHeight: CGFloat = 60
    var textColor = UIColor(red: 0.42, green: 0.65, blue: 0.98, alpha: 1)
    var font = UIFont.systemFont(ofSize: 14)
}

open
class XYAlertSheetController: UIViewController {
    
    private var contentView = UIView()
    private var customHeader: UIView?
    
    private var titleString: String? = nil
    private var subTitleString: String? = nil
    private var actions: [XYAlertSheetAction] = []
    private var block: XYAlertSheetBlock?
    
    @objc public class func showCustom(on
                                        vc: UIViewController,
                                       title: String?,
                                       subTitle: String?,
                                       actions: [XYAlertSheetAction],callBack: XYAlertSheetBlock?) {
        
        var actions_ = actions
        let model = XYAlertSheetAction()
        model.title = "取消"
        actions_.append(model)
        
        let alertSheet = XYAlertSheetController()
        alertSheet.titleString = title
        alertSheet.subTitleString = subTitle
        alertSheet.block = callBack
        alertSheet.actions = actions_
        vc.present(alertSheet, animated: false, completion: nil)
    }
    
    /// 展示自定义的 headerView， 外部需指定其 frame.size.height
    @objc public class func showCustom(on
                                        vc: UIViewController,
                                       customHeader:UIView,
                                       actions: [XYAlertSheetAction],callBack: XYAlertSheetBlock?) {
        
        var actions_ = actions
        let model = XYAlertSheetAction()
        model.title = "取消"
        actions_.append(model)
        
        let alertSheet = XYAlertSheetController()
        alertSheet.customHeader = customHeader
        alertSheet.block = callBack
        alertSheet.actions = actions_
        vc.present(alertSheet, animated: false, completion: nil)
    }
    
    @objc public class func showDefault(on vc: UIViewController,
                                        title: String?,
                                        subTitle: String?,
                                     actions: [String],
                                     callBack: XYAlertSheetBlock?) {
        
        var actionModels = [XYAlertSheetAction]()
        for title in actions {
            let model = XYAlertSheetAction()
            model.title = title
            actionModels.append(model)
        }
        showCustom(on: vc, title: title, subTitle: subTitle, actions: actionModels, callBack: callBack)
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
        self.view.tag = -1
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionClick(tap:)))
        view.addGestureRecognizer(tap)

        buildUI()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        start()
    }
}


extension XYAlertSheetController {
    
    func buildUI() {
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
        }
        
        // 创建 header
        var lastView: UIView = buildHeader()
        
        // 创建 actions
        var index = -1
        for action in actions {
            index += 1
            
            let line = UIView()
            line.backgroundColor = UIColor(white: 0.8, alpha: 1)
            if action == actions.last {
                line.backgroundColor = UIColor(white: 0.965, alpha: 1)
            }
            
            let label = UILabel()
            label.text = action.title
            label.textColor = action.textColor
            label.font = action.font
            label.textAlignment = .center
            label.numberOfLines = 0
            label.isUserInteractionEnabled = true
            label.tag = index
            if action == actions.last {
                label.textColor = .lightGray
                label.tag = -1
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(actionClick(tap:)))
            label.addGestureRecognizer(tap)
            
            contentView.addSubview(line)
            contentView.addSubview(label)
            
            line.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                
                if action == actions.first, customHeader == nil {
                    make.top.equalTo(lastView.snp.bottom).offset(20)
                }else{
                    make.top.equalTo(lastView.snp.bottom)
                }
                
                if action == actions.last {
                    make.height.equalTo(8)
                }else{
                    make.height.equalTo(0.5)
                }
            }
            
            lastView = line
            
            label.snp.makeConstraints { (make) in
                
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.top.equalTo(lastView.snp.bottom)
                make.height.equalTo(action.defaultHeight)
                
                if action == actions.last {
                    make.bottom.equalToSuperview().offset(-34)
                }
            }
            lastView = label
        }
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func buildHeader() -> UIView {
        
        var resultView = UIView()
        
        if let customHeaderView = customHeader {
            contentView.addSubview(customHeaderView)
            customHeaderView.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.top.equalToSuperview()
                if customHeaderView.frame.size.height > 0 {
                    make.height.equalTo(customHeaderView.frame.size.height)
                } 
            }
            
            resultView = customHeaderView
        }else{
            
            let titleLabel = UILabel()
            titleLabel.text = titleString
            titleLabel.textColor = .black
            titleLabel.font = UIFont.systemFont(ofSize: 17)
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            contentView.addSubview(titleLabel)
            
            let subTitleLabel = UILabel()
            subTitleLabel.text = subTitleString
            subTitleLabel.textColor = .gray
            subTitleLabel.font = UIFont.systemFont(ofSize: 12)
            subTitleLabel.textAlignment = .center
            subTitleLabel.numberOfLines = 0
            contentView.addSubview(subTitleLabel)
            
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.top.equalToSuperview().offset(20)
            }
            
            subTitleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                if let count = subTitleString?.count, count > 0 {
                    make.top.equalTo(titleLabel.snp.bottom).offset(10)
                }else{
                    make.top.equalTo(titleLabel.snp.bottom)
                }
            }
            
            resultView = subTitleLabel
        }
        
        return resultView
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
        
        let isIPhoneX = UIScreen.main.bounds.size.height >= 812
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
        
        UIView.animate(withDuration: 0.15) {
            self.view.backgroundColor = .clear
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


