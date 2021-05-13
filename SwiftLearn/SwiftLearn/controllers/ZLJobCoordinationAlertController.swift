//
//  ZLJobCoordinationAlertController.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/5/11.
//

import UIKit

open
class ZLJobCoordinationAlertController: UIViewController {
    
    // 头部图
    open var topImage: UIImage?
    // 高度
    open var topCons: Int?
    // 取消回调
    open var cancelBlock: (() -> ())?
    
    open override var modalPresentationStyle: UIModalPresentationStyle{
        set{}
        get{
            .custom
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        
//        let imgData = UIImage(named: "job_coordination")?.pngData()
//        UserDefaults.standard.setValue(imgData, forKey: "ddd")
//
//        //---
//
//        let topImage_data = UserDefaults.standard.object(forKey: "ddd")
//        guard let top_data = topImage_data as? Data ,let img = UIImage(data: top_data) else {
//            end()
//            return
//        }
        
        guard let img = topImage else {
            okBtnClick() // 取消
            return
        }
        
        // -- 这个高度为 nav + 一个协助的高度
        let topIV = UIImageView(image: img)
        topIV.sizeToFit()
        view.addSubview(topIV)
        topIV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topCons!)
            make.height.equalTo(76)
        }
        
        //---

        let bottomView = UIView()
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topIV.snp.bottom)
        }
        let image_bg = UIImage(named: "job_coordination")
        let bg_IV = UIImageView(image: image_bg)
        bg_IV.sizeToFit()
        bottomView.addSubview(bg_IV)
        
        bg_IV.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.center.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let image_ok = UIImage(named: "job_okBtn")
        let okBtn = UIButton()
        okBtn.setImage(image_ok, for: .normal)
        okBtn.sizeToFit()
        bottomView.addSubview(okBtn)
        okBtn.addTarget(self, action: #selector(okBtnClick), for: .touchUpInside)
        
        okBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bg_IV) .offset(-20)
            make.centerY.equalToSuperview()
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        start()
    }
    
    @objc func okBtnClick(){
        end()
        cancelBlock?()
    }
}


// 动画
extension ZLJobCoordinationAlertController {
    
    func start() {
        UIView.animate(withDuration: 0.25) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
    }
    
    func end() {
        
        UIView.animate(withDuration: 0.15) {
            self.view.backgroundColor = .clear
        } completion: { (success) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
